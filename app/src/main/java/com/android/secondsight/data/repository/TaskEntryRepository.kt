package com.android.secondsight.data.repository

import com.android.secondsight.data.TaskEntry

interface TaskEntryRepository {
    fun getTaskEntries(taskId: String): List<TaskEntry>
    fun getTaskEntry(id: String): TaskEntry
    fun addTaskEntry(taskId: String): TaskEntry
    fun pauseTaskEntry(id: String): TaskEntry
    fun resumeTaskEntry(id: String): TaskEntry
    fun endTaskEntry(id: String): TaskEntry
    fun deleteTaskEntry(id: String)
}