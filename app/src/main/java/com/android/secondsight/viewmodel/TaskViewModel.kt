package com.android.secondsight.viewmodel

import androidx.lifecycle.ViewModel
import com.android.secondsight.data.repository.TaskEntryRepository
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject


class TaskViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository,
    @Assisted private val taskId: String
) : ViewModel() {
    private val _taskEntries = taskEntryRepository.getTaskEntries(taskId)
    val taskEntries = _taskEntries
    fun addTaskEntry(): String {
        return taskEntryRepository.addTaskEntry(taskId).id
    }

}

@AssistedFactory
interface TaskViewModelFactory {
    fun create(taskId: String): TaskViewModel
}
