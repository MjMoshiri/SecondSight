package com.android.secondsight.data.repository.dummy

import com.android.secondsight.data.Interval
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries
import com.android.secondsight.data.repository.TaskEntryRepository
import kotlinx.coroutines.flow.Flow
import java.time.Duration
import java.time.LocalDateTime

class InMemoryTaskEntryRepository : TaskEntryRepository {
    private val taskEntries = mutableMapOf<Long, TaskEntry>()
    private var currentId: Long = 0

    override fun getTaskEntry(id: Long) : Flow<TaskEntry> {
       throw NotImplementedError("Not implemented")
    }

    override fun getTaskEntries(taskId: Long): Flow<TaskWithEntries> {
        throw NotImplementedError("Not implemented")
    }

    override fun addTaskEntry(taskId: Long): TaskEntry {
        val curTime = LocalDateTime.now()
        val taskEntry = TaskEntry(
            taskId = taskId,
            id = currentId++,
            start = curTime,
            end = null,
            curStart = curTime,
            intervals = emptyList<Interval>(),
            duration = Duration.ZERO,
            isRunning = true,
            isComplete = false
        )
        taskEntries[taskEntry.id] = taskEntry
        return taskEntry
    }

    override suspend fun pauseTaskEntry(id: Long){
        val taskEntry = taskEntries[id] ?: throw NoSuchElementException("Can't find the TaskEntry")
        val curTime = LocalDateTime.now()
        val start = taskEntry.curStart!!
        val duration = taskEntry.duration + Duration.between(start, curTime)
        taskEntries[id] = taskEntry.copy(
            curStart = null, intervals = taskEntry.intervals!!.plus(
                Interval(
                    start,
                    end = curTime,
                    duration = Duration.between(start, curTime),
                )
            ), duration = duration, isRunning = false
        )
    }

    override suspend fun resumeTaskEntry(id: Long){
        val taskEntry = taskEntries[id] ?: throw NoSuchElementException("Can't find the TaskEntry")
        val curTime = LocalDateTime.now()
        taskEntries[id] = taskEntry.copy(curStart = curTime, isRunning = true)
    }

    override suspend fun endTaskEntry(id: Long) {
        val taskEntry = taskEntries[id] ?: throw NoSuchElementException("Can't find the TaskEntry")
        val end = LocalDateTime.now()
        if (taskEntry.isRunning == true) {
            val start = taskEntry.curStart!!
            val duration = taskEntry.duration + Duration.between(start, end)
            taskEntries[id] = taskEntry.copy(
                end = end, curStart = null, intervals = taskEntry.intervals!!.plus(
                    Interval(
                        start, end, Duration.between(start, end)
                    )
                ), duration = duration, isRunning = false, isComplete = true
            )
        } else {
            taskEntries[id] = taskEntry.copy(isComplete = true, end = end)
        }
    }

    override suspend fun deleteTaskEntry(id: Long) {
        taskEntries.remove(id)
    }
}