package com.android.secondsight.viewmodel


import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.android.secondsight.data.TaskWithEntries
import com.android.secondsight.data.repository.TaskEntryRepository
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class TaskViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository, @Assisted private val taskId: Long
) : ViewModel() {
    private val viewModelJob = SupervisorJob()

    private val viewModelScope = CoroutineScope(Dispatchers.Main + viewModelJob)

    private val _taskEntries = MutableLiveData<TaskWithEntries>()


    init {
        updateTaskEntry()
    }

    fun updateTaskEntry() {
        viewModelScope.launch {
            val taskEntries = withContext(Dispatchers.IO) {
                taskEntryRepository.getTaskEntries(taskId)
            }
            _taskEntries.postValue(taskEntries)
        }
    }

    val taskEntries: LiveData<TaskWithEntries>
        get() = _taskEntries

    fun addTaskEntry(createEntry: (Long) -> Unit) {
        viewModelScope.launch(Dispatchers.IO) {
            val id = taskEntryRepository.addTaskEntry(taskId).id
            withContext(Dispatchers.Main) {
                createEntry(id)
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        viewModelJob.cancel()
    }
}

@AssistedFactory
interface TaskViewModelFactory {
    fun create(taskId: Long): TaskViewModel
}


