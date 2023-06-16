package com.android.secondsight.databases

import androidx.room.Database
import androidx.room.RoomDatabase
import com.android.secondsight.data.Task
import com.android.secondsight.data.TaskEntry

@Database(entities = [Task::class, TaskEntry::class], version = 1, exportSchema = false)
abstract class AppDB : RoomDatabase() {
    abstract fun taskDao(): com.android.secondsight.data.doa.TaskDao
    abstract fun taskEntryDao(): com.android.secondsight.data.doa.TaskEntryDao
}