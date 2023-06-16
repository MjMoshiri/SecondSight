package com.android.secondsight.data.repository.Room

import com.android.secondsight.data.Interval
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries
import com.android.secondsight.data.doa.TaskEntryDao
import com.android.secondsight.data.repository.TaskEntryRepository
import java.time.Duration
import java.time.LocalDateTime
import javax.inject.Inject

class RoomTaskEntryRepository @Inject constructor(
    private val taskEntryDao: TaskEntryDao
) : TaskEntryRepository {

    override fun getTaskEntries(taskId: Long): TaskWithEntries {
        return taskEntryDao.getTaskEntries(taskId)
    }

    override fun getTaskEntry(id: Long): TaskEntry {
        return taskEntryDao.getTaskEntry(id)
    }

    override fun addTaskEntry(taskId: Long): TaskEntry {
        val curTime = LocalDateTime.now()
        val taskEntry = TaskEntry(
            taskId = taskId,
            id = 0,
            start = curTime,
            end = null,
            curStart = curTime,
            intervals = emptyList<Interval>(),
            duration = Duration.ZERO,
            isRunning = true,
            isComplete = false
        )
        val id = taskEntryDao.addTaskEntry(taskEntry)
        return taskEntry.copy(id = id)
    }

    override fun pauseTaskEntry(id: Long): TaskEntry {
        val taskEntry = taskEntryDao.getTaskEntry(id)
        val curTime = LocalDateTime.now()
        val start = taskEntry.curStart!!
        val duration = taskEntry.duration + Duration.between(start, curTime)
        val pausedTask = taskEntry.copy(
            curStart = null, intervals = taskEntry.intervals!!.plus(
                Interval(
                    start, end = curTime, duration = Duration.between(start, curTime)
                )
            ), duration = duration, isRunning = false
        )
        taskEntryDao.updateTaskEntry(pausedTask)
        return pausedTask
    }

    override fun resumeTaskEntry(id: Long): TaskEntry {
        val taskEntry = taskEntryDao.getTaskEntry(id)
        val curTime = LocalDateTime.now()
        val resumedTask = taskEntry.copy(curStart = curTime, isRunning = true)
        taskEntryDao.updateTaskEntry(resumedTask)
        return resumedTask
    }

    override fun endTaskEntry(id: Long): TaskEntry {
        val taskEntry = taskEntryDao.getTaskEntry(id)
        val end = LocalDateTime.now()
        lateinit var endedTask: TaskEntry
        if (taskEntry.isRunning == true) {
            val start = taskEntry.curStart!!
            val duration = taskEntry.duration + Duration.between(start, end)
            endedTask = taskEntry.copy(
                end = end, curStart = null, intervals = taskEntry.intervals!!.plus(
                    Interval(
                        start, end, Duration.between(start, end)
                    )
                ), duration = duration, isRunning = false, isComplete = true
            )
            taskEntryDao.updateTaskEntry(endedTask)
        } else {
            endedTask = taskEntry.copy(isComplete = true, end = end)
            taskEntryDao.updateTaskEntry(endedTask)

        }
        return endedTask
    }

    override fun deleteTaskEntry(id: Long) {
        taskEntryDao.deleteTaskEntry(id)
    }
}
