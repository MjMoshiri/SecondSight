package com.android.secondsight.viewmodel.provider

import androidx.lifecycle.ViewModelProvider
import com.android.secondsight.viewmodel.EntryViewModel
import com.android.secondsight.viewmodel.EntryViewModelFactory
import com.android.secondsight.viewmodel.TaskViewModel
import com.android.secondsight.viewmodel.TaskViewModelFactory
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class vmProvider @Inject constructor(
    private val entryFactory: EntryViewModelFactory,
    private val taskFactory: TaskViewModelFactory,
) : ViewModelProvider.Factory {
    private val entryMap = mutableMapOf<Long, EntryViewModel>()
    private val taskMap = mutableMapOf<Long, TaskViewModel>()
    fun getEntryViewModel(id: Long): EntryViewModel {
        return entryMap.getOrPut(id) {
            entryFactory.create(id)
        }
    }

    fun getTaskViewModel(id: Long): TaskViewModel {
        return taskMap.getOrPut(id) {
            taskFactory.create(id)
        }
    }

    fun removeTaskViewModel(id: Long) {
        taskMap.remove(id)
    }

    fun removeEntryViewModel(id: Long) {
        entryMap.remove(id)
    }
}