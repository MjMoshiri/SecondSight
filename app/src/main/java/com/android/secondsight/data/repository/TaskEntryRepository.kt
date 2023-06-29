package com.android.secondsight.data.repository

import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries
import kotlinx.coroutines.flow.Flow

interface TaskEntryRepository {
    fun getTaskEntries(taskId: Long): Flow<TaskWithEntries>
    fun getTaskEntry(id: Long): Flow<TaskEntry>
    fun addTaskEntry(taskId: Long): TaskEntry
    suspend fun pauseTaskEntry(id: Long)
    suspend fun resumeTaskEntry(id: Long)
    suspend fun endTaskEntry(id: Long)
    suspend fun deleteTaskEntry(id: Long)
}