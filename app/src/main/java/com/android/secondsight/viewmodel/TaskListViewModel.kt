package com.android.secondsight.viewmodel

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.android.secondsight.data.Task
import com.android.secondsight.data.repository.TaskRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import javax.inject.Inject

@HiltViewModel
class TaskListViewModel @Inject constructor(
    private val taskRepository: TaskRepository
) : ViewModel() {

    private val viewModelJob = SupervisorJob()

    private val viewModelScope = CoroutineScope(Dispatchers.Main + viewModelJob)

    private val _tasks = MutableLiveData<List<Task>?>()
    val tasks: MutableLiveData<List<Task>?> = _tasks

    init {
        loadTasks()
    }

    private fun loadTasks() {
        viewModelScope.launch {
            _tasks.value = withContext(Dispatchers.IO) {
                taskRepository.getTasks()
            }
        }
    }

    fun addTask(name: String, description: String) {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                taskRepository.addTask(name, description)
                _tasks.postValue(taskRepository.getTasks())
            }

        }
    }

    fun deleteTask(task: Task) {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                taskRepository.deleteTask(task)
                _tasks.postValue(taskRepository.getTasks())
            }
        }
    }

    fun updateTask(name: String? = null, description: String? = null, task: Task) {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                taskRepository.updateTask(name, description, task)
                _tasks.postValue(taskRepository.getTasks())
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        viewModelJob.cancel()
    }
}

