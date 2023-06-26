package com.android.secondsight.viewmodel


import android.content.Context
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
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
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.time.Duration

class EntryViewModel @AssistedInject constructor(
    private val taskEntryRepository: TaskEntryRepository,
    private val context: Context,
    @Assisted private val entryId: Long,
) : ViewModel() {

    private val viewModelJob = SupervisorJob()

    private val viewModelScope = CoroutineScope(Dispatchers.Main + viewModelJob)

    private val _taskEntry = MutableLiveData<TaskEntry>()

    val taskEntry: LiveData<TaskEntry>
        get() = _taskEntry

    private val _time = MutableLiveData<Duration>()

    val time: LiveData<Duration>
        get() = _time

    private val _isCompleted = MutableLiveData<Boolean>()

    val isCompleted: LiveData<Boolean>
        get() = _isCompleted


    init {
        loadTaskEntry()
        updateTime()
    }


    private fun runNotificationService(isRunning: Boolean, isCompleted: Boolean) {
        if (isCompleted) {
            EntryNotificationService(context, entryId, false).stop()
        } else {
            EntryNotificationService(context, entryId, isRunning).show()
        }
    }

    private fun loadTaskEntry() {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                val taskEntry = taskEntryRepository.getTaskEntry(entryId)
                _taskEntry.postValue(taskEntry)
                _time.postValue(taskEntry.duration)
                _isCompleted.postValue(taskEntry.isComplete)
                runNotificationService(taskEntry.isRunning!!, taskEntry.isComplete)
            }
        }
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
                val curDuration = _taskEntry.value?.duration!!
                _time.postValue(curDuration.plus(curTime))
                delay(5)
            }
        }
    }

    fun pauseTaskEntry() {
        viewModelScope.launch {
            if (_taskEntry.value?.isRunning == true) {
                val pausedEntry = withContext(Dispatchers.IO) {
                    taskEntryRepository.pauseTaskEntry(entryId)
                }
                _taskEntry.postValue(pausedEntry)
                _time.postValue(pausedEntry.duration)
                runNotificationService(isRunning = false, isCompleted = false)
            }
        }
    }

    fun resumeTaskEntry() {
        viewModelScope.launch {
            if (_taskEntry.value?.isRunning == false) {
                val resumedEntry = withContext(Dispatchers.IO) {
                    taskEntryRepository.resumeTaskEntry(entryId)
                }
                _taskEntry.postValue(resumedEntry)
                updateTime()
                runNotificationService(isRunning = true, isCompleted = false)
            }
        }
    }

    fun endTaskEntry() {
        viewModelScope.launch {
            if (_taskEntry.value?.isComplete == false) {
                val endedEntry = withContext(Dispatchers.IO) {
                    taskEntryRepository.endTaskEntry(entryId)
                }
                _taskEntry.postValue(endedEntry)
                _isCompleted.postValue(true)
                runNotificationService(isRunning = false, isCompleted = true)
            }
        }
    }

    fun deleteTaskEntry() {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                taskEntryRepository.deleteTaskEntry(entryId)
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        viewModelJob.cancel()
    }
}

@AssistedFactory
interface EntryViewModelFactory {
    fun create(entryId: Long): EntryViewModel
}



