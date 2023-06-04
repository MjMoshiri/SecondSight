package com.android.secondsight.data.repository.dummy

import com.android.secondsight.data.Interval
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.repository.TaskEntryRepository
import kotlin.time.Duration
import kotlin.time.ExperimentalTime
import kotlin.time.TimeSource

@OptIn(ExperimentalTime::class)
class InMemoryTaskEntryRepository : TaskEntryRepository {
    private val taskEntries = mutableMapOf<String, TaskEntry>()
    private var currentId = 0
    private var currentIntervalId = 0

    override fun getTaskEntry(id: String): TaskEntry {
        return taskEntries[id]
            ?: throw NoSuchElementException("Can't find the TaskEntry")
    }


    override fun addTaskEntry(taskId: String): TaskEntry {
        val curTime = TimeSource.Monotonic.markNow()
        val taskEntry = TaskEntry(
            taskId, currentId++.toString(), start = curTime,
            end = null, curStart = curTime, intervals = emptyList<Interval>(),
            duration = Duration.ZERO, isRunning = true, isComplete = false
        )
        taskEntries[taskEntry.id] = taskEntry
        return taskEntry
    }

    override fun pauseTaskEntry(id: String): TaskEntry {
        val taskEntry = taskEntries[id]
            ?: throw NoSuchElementException("Can't find the TaskEntry")
        val curTime = TimeSource.Monotonic.markNow()
        val start = taskEntry.curStart!!
        val duration = taskEntry.duration!!.plus(curTime - start)
        taskEntries[id] = taskEntry.copy(
            curStart = null,
            intervals = taskEntry.intervals!!.plus(
                Interval(
                    start,
                    curTime,
                    curTime - start,
                    currentIntervalId++.toString()
                )
            ),
            duration = duration,
            isRunning = false
        )
        return taskEntries[id]!!
    }

    override fun resumeTaskEntry(id: String): TaskEntry {
        val taskEntry = taskEntries[id]
            ?: throw NoSuchElementException("Can't find the TaskEntry")
        val curTime = TimeSource.Monotonic.markNow()
        taskEntries[id] = taskEntry.copy(curStart = curTime, isRunning = true)
        return taskEntries[id]!!
    }

    override fun endTaskEntry(id: String): TaskEntry {
        val taskEntry = taskEntries[id]
            ?: throw NoSuchElementException("Can't find the TaskEntry")
        val curTime = TimeSource.Monotonic.markNow()
        val start = taskEntry.curStart!!
        val duration = taskEntry.duration!!.plus(curTime - start)
        taskEntries[id] = taskEntry.copy(
            curStart = null,
            intervals = taskEntry.intervals!!.plus(
                Interval(
                    start,
                    curTime,
                    curTime - start,
                    currentIntervalId++.toString()
                )
            ),
            duration = duration,
            isRunning = false,
            isComplete = true
        )
        return taskEntries[id]!!
    }

    override fun deleteTaskEntry(id: String) {
        taskEntries.remove(id)
    }
}