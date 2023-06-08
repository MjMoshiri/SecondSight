package com.android.secondsight.viewmodel

import androidx.lifecycle.ViewModel
import com.android.secondsight.data.repository.TaskEntryRepository
import dagger.assisted.Assisted
import dagger.assisted.AssistedInject


class EntryViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository, @Assisted private val entryId: String
) : ViewModel() {

    private val _taskEntry = taskEntryRepository.getTaskEntry(entryId)
    val taskEntry = _taskEntry

    fun pauseTaskEntry() {
        if (_taskEntry.isRunning!!) {
            taskEntryRepository.pauseTaskEntry(entryId)
        }
    }

    fun resumeTaskEntry() {
        if (!_taskEntry.isRunning!!) {
            taskEntryRepository.resumeTaskEntry(entryId)
        }
    }

    fun endTaskEntry() {
        if (_taskEntry.isRunning!!) {
            taskEntryRepository.endTaskEntry(entryId)
        }
    }
}