package com.android.secondsight.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.android.secondsight.data.Task
import com.android.secondsight.data.repository.TaskRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class TaskListViewModel @Inject constructor(
    private val taskRepository: TaskRepository
) : ViewModel() {

    private val _tasks = MutableLiveData<List<Task>>()
    val tasks: LiveData<List<Task>> = _tasks

    init {
        loadTasks()
    }

    private fun loadTasks() {
        _tasks.value = taskRepository.getTasks()
    }

    fun addTask(name: String, description: String) {
        taskRepository.addTask(name, description)
    }

    fun deleteTask(task: Task) {
        taskRepository.deleteTask(task)
    }
}
