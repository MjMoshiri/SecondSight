package com.android.secondsight.data.doa

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Transaction
import androidx.room.Update
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.data.TaskWithEntries

@Dao
interface TaskEntryDao {
    @Transaction
    @Query("SELECT * FROM Task WHERE id = :taskId")
    fun getTaskEntries(taskId: Long): TaskWithEntries

    @Query("SELECT * FROM TaskEntry WHERE id = :id")
    fun getTaskEntry(id: Long): TaskEntry

    @Insert
    fun addTaskEntry(taskEntry: TaskEntry): Long

    @Update
    fun updateTaskEntry(taskEntry: TaskEntry)

    @Query("DELETE FROM TaskEntry WHERE id = :id")
    fun deleteTaskEntry(id: Long)

}
