package com.android.secondsight.di

import android.content.Context
import androidx.room.Room
import com.android.secondsight.data.doa.TaskDao
import com.android.secondsight.data.doa.TaskEntryDao
import com.android.secondsight.data.repository.Room.RoomTaskEntryRepository
import com.android.secondsight.data.repository.Room.RoomTaskRepository
import com.android.secondsight.data.repository.TaskEntryRepository
import com.android.secondsight.data.repository.TaskRepository
import com.android.secondsight.databases.AppDB
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DataSource {
    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext appContext: Context): AppDB {
        return Room.databaseBuilder(
            appContext, AppDB::class.java, "database-name"
        ).build()
    }

    @Provides
    fun provideTaskDao(database: AppDB): TaskDao {
        return database.taskDao()
    }

    @Provides
    fun provideTaskEntryDao(database: AppDB): TaskEntryDao {
        return database.taskEntryDao()
    }

    @Provides
    @Singleton
    fun provideTaskEntryRepository(
        taskEntryDao: TaskEntryDao
    ): TaskEntryRepository {
        return RoomTaskEntryRepository(taskEntryDao)
    }

    @Provides
    @Singleton
    fun provideTaskRepository(
        taskDao: TaskDao
    ): TaskRepository {
        return RoomTaskRepository(taskDao)
    }

    @Provides
    @Singleton
    fun provideContext(@ApplicationContext appContext: Context): Context {
        return appContext
    }
}