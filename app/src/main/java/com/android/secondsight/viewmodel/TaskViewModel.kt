package com.android.secondsight.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.repository.TaskEntryRepository
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject


class TaskViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository, @Assisted private val taskId: String
) : ViewModel() {
    private val _taskEntries = MutableLiveData<List<TaskEntry>>().apply {
        value = taskEntryRepository.getTaskEntries(taskId)
    }


    fun updateTaskEntry() {
        _taskEntries.postValue(taskEntryRepository.getTaskEntries(taskId))
    }

    val taskEntries: LiveData<List<TaskEntry>> get() = _taskEntries

    fun addTaskEntry(): String {
        val entry = taskEntryRepository.addTaskEntry(taskId)
        _taskEntries.postValue(taskEntryRepository.getTaskEntries(taskId))
        return entry.id
    }

}

@AssistedFactory
interface TaskViewModelFactory {
    fun create(taskId: String): TaskViewModel
}
