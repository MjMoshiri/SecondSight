package com.android.secondsight.viewmodel

import androidx.lifecycle.ViewModel
import com.android.secondsight.data.TaskEntry
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
    @Assisted private val entryId: Long,
) : ViewModel() {

    private val viewModelJob = SupervisorJob()
    private val viewModelScope = CoroutineScope(Dispatchers.Main + viewModelJob)
    private val _time = MutableStateFlow<Duration?>(null)
    private val _taskEntry = MutableStateFlow<TaskEntry?>(null)
    private var isLoading = true


    init {
        viewModelScope.launch {
            taskEntryRepository.getTaskEntry(entryId).collect { taskEntry ->
                _time.value = taskEntry?.duration
                _taskEntry.value = taskEntry
                isLoading = false
                if (taskEntry?.isRunning == true) {
                    updateTime()
                }
            }
        }
    }

    val time: StateFlow<Duration?>
        get() = _time

    val taskEntry: StateFlow<TaskEntry?>
        get() = _taskEntry

    fun setNotif(isCompleted: Boolean) = viewModelScope.launch {
        if (isCompleted) {
            notificationManager.stop(entryId)
        } else {
            notificationManager.show(entryId, _taskEntry.value?.isRunning!!)
        }
    }

    fun setNotif() = viewModelScope.launch {
        while (isLoading) {
            delay(10)
        }
        setNotif(_taskEntry.value?.isComplete!!)
    }

    private fun updateTime() = viewModelScope.launch {
        while (true) {
            if (_taskEntry.value?.isRunning == true) {
                val taskEntry = taskEntryRepository.getTaskEntry(entryId).firstOrNull()
                val curStart = taskEntry?.curStart
                curStart?.let {
                    val curTime = Duration.between(it, LocalDateTime.now())
                    _time.value = taskEntry.duration.plus(curTime)
                }
            } else {
                break
            }
            delay(5)
        }
    }

    fun pauseTaskEntry() = viewModelScope.launch {
        if (_taskEntry.value?.isRunning == true) {
            isLoading = true
            taskEntryRepository.pauseTaskEntry(entryId)
            setNotif()
        }
    }

    fun resumeTaskEntry() = viewModelScope.launch {
        if (_taskEntry.value?.isRunning == false) {
            isLoading = true
            taskEntryRepository.resumeTaskEntry(entryId)
            setNotif()
        }
    }

    fun endTaskEntry() = viewModelScope.launch {
        if (_taskEntry.value?.isComplete == false) {
            taskEntryRepository.endTaskEntry(entryId)
            setNotif(true)
        }
    }
}


@AssistedFactory
interface EntryViewModelFactory {
    fun create(entryId: Long): EntryViewModel
}



