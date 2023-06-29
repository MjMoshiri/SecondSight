package com.android.secondsight.viewmodel.provider

import androidx.lifecycle.ViewModelProvider
import com.android.secondsight.viewmodel.EntryViewModel
import com.android.secondsight.viewmodel.EntryViewModelFactory
import com.android.secondsight.viewmodel.TaskViewModel
import com.android.secondsight.viewmodel.TaskViewModelFactory
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ViewModelProvider @Inject constructor(
    private val entryFactory: EntryViewModelFactory,
    private val taskFactory: TaskViewModelFactory,
) : ViewModelProvider.Factory{
    fun getEntryViewModel(id: Long): EntryViewModel {
        return entryFactory.create(id)
    }

    fun getTaskViewModel(id: Long): TaskViewModel {
        return taskFactory.create(id)
    }
}