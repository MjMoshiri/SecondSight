package com.android.secondsight.data.repository

import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries
import kotlinx.coroutines.flow.Flow

interface TaskEntryRepository {
    fun getTaskEntries(taskId: Long): Flow<TaskWithEntries>
    fun getTaskEntry(id: Long): TaskEntry
    fun addTaskEntry(taskId: Long): TaskEntry
    fun pauseTaskEntry(id: Long): TaskEntry
    fun resumeTaskEntry(id: Long): TaskEntry
    fun endTaskEntry(id: Long): TaskEntry
    fun deleteTaskEntry(id: Long)
}