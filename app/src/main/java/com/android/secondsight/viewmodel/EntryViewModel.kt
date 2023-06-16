package com.android.secondsight.viewmodel


import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.repository.TaskEntryRepository
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
    private val taskEntryRepository: TaskEntryRepository, @Assisted private val entryId: Long
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

    private val _isRunning = MutableLiveData<Boolean>()

    val isRunning: LiveData<Boolean>
        get() = _isRunning

    init {
        loadTaskEntry()
        updateTime()
    }

    private fun loadTaskEntry() {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                val taskEntry = taskEntryRepository.getTaskEntry(entryId)
                _taskEntry.postValue(taskEntry)
                _time.postValue(taskEntry.duration)
                _isCompleted.postValue(taskEntry.isComplete)
                _isRunning.postValue(taskEntry.isRunning)
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
                _time.postValue(_taskEntry.value?.duration?.plus(curTime))
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
                _isRunning.postValue(false)
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
                _isRunning.postValue(true)
                updateTime()
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
                _isRunning.postValue(false)
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



