package com.android.secondsight.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.repository.TaskEntryRepository
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.time.Duration


class EntryViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository, @Assisted private val entryId: String
) : ViewModel() {
    private val _taskEntry: MutableLiveData<TaskEntry> = MutableLiveData<TaskEntry>().apply {
        value = taskEntryRepository.getTaskEntry(entryId)
    }
    val taskEntry: LiveData<TaskEntry> get() = _taskEntry
    private val _time = MutableLiveData<Duration>().apply {
        value = taskEntryRepository.getTaskEntry(entryId).duration
    }
    val time: LiveData<Duration> get() = _time
    private val _isCompleted = MutableLiveData<Boolean>().apply {
        value = taskEntryRepository.getTaskEntry(entryId).isComplete
    }
    val isCompleted: LiveData<Boolean> get() = _isCompleted

    init {
        updateTime()
    }

    private fun updateTime() {
        viewModelScope.launch(Dispatchers.IO) {
            while (_taskEntry.value?.curStart == null) {
                delay(3)
            }
            while (true) {
                val curStart = _taskEntry.value?.curStart
                curStart ?: break
                val curTime = Duration.between(
                    curStart, java.time.LocalDateTime.now()
                )
                _time.postValue(_taskEntry.value?.duration?.plus(curTime))
                delay(5)
            }
        }

    }

    fun pauseTaskEntry() {
        if (_taskEntry.value?.isRunning == true) {
            _taskEntry.postValue(taskEntryRepository.pauseTaskEntry(entryId))
        }
    }

    fun resumeTaskEntry() {
        if (_taskEntry.value?.isRunning == false) {
            _taskEntry.postValue(taskEntryRepository.resumeTaskEntry(entryId))
            updateTime()
        }
    }

    fun endTaskEntry() {
        if (_taskEntry.value?.isComplete == false) {
            _taskEntry.postValue(taskEntryRepository.endTaskEntry(entryId))
            _isCompleted.postValue(true)
        }
    }
}

@AssistedFactory
interface EntryViewModelFactory {
    fun create(entryId: String): EntryViewModel
}

