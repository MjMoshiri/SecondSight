package com.android.secondsight.data.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Update
import com.android.secondsight.data.Task

@Dao
interface TaskDao {
    @Query("SELECT * FROM Task")
    fun getTasks(): List<Task>

    @Query("SELECT * FROM Task WHERE id = :id")
    fun getTask(id: Long): Task

    @Insert()
    fun addTask(task: Task): Long

    @Update
    fun updateTask(task: Task)

    @Delete
    fun deleteTask(task: Task)
}