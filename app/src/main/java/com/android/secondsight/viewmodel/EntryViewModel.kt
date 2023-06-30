package com.android.secondsight.viewmodel

import androidx.lifecycle.ViewModel
import com.android.secondsight.data.repository.TaskEntryRepository
import com.android.secondsight.ui.notif.EntryNotificationService
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.launch
import java.time.Duration
import java.time.LocalDateTime

class EntryViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository,
    private val notificationManager: EntryNotificationService,
    @Assisted val entryId: Long,
) : ViewModel() {

    private val viewModelJob = SupervisorJob()
    private val viewModelScope = CoroutineScope(Dispatchers.Main + viewModelJob)
    private val _time = MutableStateFlow<Duration?>(null)
    private val _isComplete = MutableStateFlow<Boolean?>(false)
    private val _isRunning = MutableStateFlow<Boolean?>(true)

    init {
        viewModelScope.launch {
            taskEntryRepository.getTaskEntry(entryId).collect { taskEntry ->
                _time.value = taskEntry?.duration
                _isComplete.value = taskEntry?.isComplete
                _isRunning.value = taskEntry?.isRunning
                if (taskEntry?.isRunning == true) {
                    updateTime()
                }
            }
        }
    }

    val time: StateFlow<Duration?>
        get() = _time

    val isComplete: StateFlow<Boolean?>
        get() = _isComplete

    val isRunning: StateFlow<Boolean?>
        get() = _isRunning

    fun setNotif(isCompleted: Boolean) = viewModelScope.launch {
        if (isCompleted) {
            notificationManager.stop(entryId)
        } else {
            notificationManager.show(entryId, _isRunning.value == true)
        }
    }

    fun setNotif() = viewModelScope.launch {
        while (_isComplete.value == null) {
            delay(10)
        }
        setNotif(_isComplete.value == true)
    }

    private fun updateTime() = viewModelScope.launch {
        while (true) {
            if (_isRunning.value == true) {
                val taskEntry = taskEntryRepository.getTaskEntry(entryId).firstOrNull()
                val curStart = taskEntry?.curStart
                curStart?.let {
                    val curTime = Duration.between(it, LocalDateTime.now())
                    _time.value = taskEntry.duration.plus(curTime)
                }
            } else {
                break
            }
            delay(10)
        }
    }

    fun pauseTaskEntry() = viewModelScope.launch {
        if (_isRunning.value == true) {
            taskEntryRepository.pauseTaskEntry(entryId)
            _isRunning.value = false
        }
    }

    fun resumeTaskEntry() = viewModelScope.launch {
        if (_isRunning.value == false) {
            taskEntryRepository.resumeTaskEntry(entryId)
            _isRunning.value = true
        }
    }

    fun endTaskEntry() = viewModelScope.launch {
        if (_isComplete.value == false) {
            taskEntryRepository.endTaskEntry(entryId)
            _isComplete.value = true
            setNotif(true)
        }
    }
}


@AssistedFactory
interface EntryViewModelFactory {
    fun create(entryId: Long): EntryViewModel
}



