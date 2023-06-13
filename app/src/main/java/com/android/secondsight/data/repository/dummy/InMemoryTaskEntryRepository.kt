package com.android.secondsight.data.repository.dummy

import com.android.secondsight.data.Interval
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.repository.TaskEntryRepository
import java.time.Duration
import java.time.LocalDateTime
import kotlin.time.ExperimentalTime

@OptIn(ExperimentalTime::class)
class InMemoryTaskEntryRepository : TaskEntryRepository {
    private val taskEntries = mutableMapOf<String, TaskEntry>()
    private var currentId = 0
    private var currentIntervalId = 0

    override fun getTaskEntry(id: String): TaskEntry {
        return taskEntries[id] ?: throw NoSuchElementException("Can't find the TaskEntry")
    }

    override fun getTaskEntries(taskId: String): List<TaskEntry> {
        return taskEntries.values.filter { it.taskId == taskId }
    }

    override fun addTaskEntry(taskId: String): TaskEntry {
        val curTime = LocalDateTime.now()
        val taskEntry = TaskEntry(
            taskId = taskId,
            id = currentId++.toString(),
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

    override fun pauseTaskEntry(id: String): TaskEntry {
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
                    id = currentIntervalId++.toString()
                )
            ), duration = duration, isRunning = false
        )
        return taskEntries[id]!!
    }

    override fun resumeTaskEntry(id: String): TaskEntry {
        val taskEntry = taskEntries[id] ?: throw NoSuchElementException("Can't find the TaskEntry")
        val curTime = LocalDateTime.now()
        taskEntries[id] = taskEntry.copy(curStart = curTime, isRunning = true)
        return taskEntries[id]!!
    }

    override fun endTaskEntry(id: String): TaskEntry {
        val taskEntry = taskEntries[id] ?: throw NoSuchElementException("Can't find the TaskEntry")
        val end = LocalDateTime.now()
        if (taskEntry.isRunning == true) {
            val start = taskEntry.curStart!!
            val duration = taskEntry.duration + Duration.between(start, end)
            taskEntries[id] = taskEntry.copy(
                end = end, curStart = null, intervals = taskEntry.intervals!!.plus(
                    Interval(
                        start, end, Duration.between(start, end), currentIntervalId++.toString()
                    )
                ), duration = duration, isRunning = false, isComplete = true
            )
        } else {
            taskEntries[id] = taskEntry.copy(isComplete = true, end = end)
        }
        return taskEntries[id]!!
    }

    override fun deleteTaskEntry(id: String) {
        taskEntries.remove(id)
    }
}