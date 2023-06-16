package com.android.secondsight.data.repository

import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries

interface TaskEntryRepository {
    fun getTaskEntries(taskId: Long): TaskWithEntries
    fun getTaskEntry(id: Long): TaskEntry
    fun addTaskEntry(taskId: Long): TaskEntry
    fun pauseTaskEntry(id: Long): TaskEntry
    fun resumeTaskEntry(id: Long): TaskEntry
    fun endTaskEntry(id: Long): TaskEntry
    fun deleteTaskEntry(id: Long)
}