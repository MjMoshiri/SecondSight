package com.android.secondsight.data.repository.Room

import com.android.secondsight.data.Interval
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries
import com.android.secondsight.data.dao.TaskEntryDao
import com.android.secondsight.data.repository.TaskEntryRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.withContext
import java.time.Duration
import java.time.LocalDateTime
import javax.inject.Inject

class RoomTaskEntryRepository @Inject constructor(
    private val taskEntryDao: TaskEntryDao
) : TaskEntryRepository {

    override fun getTaskEntries(taskId: Long): Flow<TaskWithEntries> {
        return taskEntryDao.getTaskEntries(taskId)
    }

    override fun getTaskEntry(id: Long): Flow<TaskEntry> {
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

    override suspend fun pauseTaskEntry(id: Long) {
        withContext(Dispatchers.IO) {
            val taskEntry = taskEntryDao.getTaskEntry(id).first()
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
        }
    }

    override suspend fun resumeTaskEntry(id: Long){
        withContext(Dispatchers.IO) {
            val taskEntry = taskEntryDao.getTaskEntry(id).first()
            val curTime = LocalDateTime.now()
            val resumedTask = taskEntry.copy(curStart = curTime, isRunning = true)
            taskEntryDao.updateTaskEntry(resumedTask)
        }
    }

    override suspend fun endTaskEntry(id: Long) {
        withContext(Dispatchers.IO) {
            val taskEntry = taskEntryDao.getTaskEntry(id).first()
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
        }
    }

    override suspend fun deleteTaskEntry(id: Long) {
        taskEntryDao.deleteTaskEntry(id)
    }

}
