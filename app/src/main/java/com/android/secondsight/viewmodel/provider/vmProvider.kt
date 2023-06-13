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
    private val entryMap = mutableMapOf<String, EntryViewModel>()
    private val taskMap = mutableMapOf<String, TaskViewModel>()
    fun getEntryViewModel(id: String): EntryViewModel {
        return entryMap.getOrPut(id) {
            entryFactory.create(id)
        }
    }

    fun getTaskViewModel(id: String): TaskViewModel {
        return taskMap.getOrPut(id) {
            taskFactory.create(id)
        }
    }

    fun removeTaskViewModel(id: String) {
        taskMap.remove(id)
    }

    fun removeEntryViewModel(id: String) {
        entryMap.remove(id)
    }
}