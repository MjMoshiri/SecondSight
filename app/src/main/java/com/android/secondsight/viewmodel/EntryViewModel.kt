package com.android.secondsight.viewmodel
import android.content.Context
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
    private val context: Context,
    @Assisted private val entryId: Long,
) : ViewModel() {


    private val viewModelJob = SupervisorJob()
    private val viewModelScope = CoroutineScope(Dispatchers.Main + viewModelJob)

    private val _taskEntry = MutableStateFlow<TaskEntry?>(null)
    private val _time = MutableStateFlow<Duration?>(null)
    private val _isCompleted = MutableStateFlow<Boolean?>(null)

    init {
        viewModelScope.launch {
            taskEntryRepository.getTaskEntry(entryId)
                .collect { taskEntry ->
                    _taskEntry.value = taskEntry
                    _time.value = taskEntry?.duration
                    _isCompleted.value = taskEntry?.isComplete
                    runNotificationService(taskEntry?.isRunning ?: false, taskEntry?.isComplete ?: false)
                    if (taskEntry?.isRunning == true) {
                        updateTime()
                    }
                }
        }
    }

    val taskEntry: StateFlow<TaskEntry?>
        get() = _taskEntry

    val time: StateFlow<Duration?>
        get() = _time

    val isCompleted: StateFlow<Boolean?>
        get() = _isCompleted

    private fun runNotificationService(isRunning: Boolean, isCompleted: Boolean) {
        if (isCompleted) {
            EntryNotificationService(context, entryId, false).stop()
        } else {
            EntryNotificationService(context, entryId, isRunning).show()
        }
    }

    private fun updateTime() = viewModelScope.launch {
        while (true) {
            val taskEntry = _taskEntry.value
            if (taskEntry?.isRunning == true) {
                val curStart = taskEntry.curStart
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
            taskEntryRepository.pauseTaskEntry(entryId)
            _taskEntry.value = taskEntryRepository.getTaskEntry(entryId).firstOrNull()

        }
    }

    fun resumeTaskEntry() = viewModelScope.launch {
        if (_taskEntry.value?.isRunning == false) {
            taskEntryRepository.resumeTaskEntry(entryId)
            _taskEntry.value = taskEntryRepository.getTaskEntry(entryId).firstOrNull()

        }
    }

    fun endTaskEntry() = viewModelScope.launch {
        if (_taskEntry.value?.isComplete == false) {
            taskEntryRepository.endTaskEntry(entryId)
            _taskEntry.value = taskEntryRepository.getTaskEntry(entryId).firstOrNull()
        }
    }

    override fun onCleared() {
        super.onCleared()
        // Ensure the notification service is stopped when ViewModel is cleared
        runNotificationService(isRunning = false, isCompleted = true)
        viewModelJob.cancel() //cancel the viewModelJob when the ViewModel is cleared
    }
}



@AssistedFactory
interface EntryViewModelFactory {
    fun create(entryId: Long): EntryViewModel
}



