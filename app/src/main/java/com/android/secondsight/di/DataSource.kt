package com.android.secondsight.di

import com.android.secondsight.data.repository.TaskRepository
import com.android.secondsight.data.repository.dummy.InMemoryTaskRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DataSource {
    @Provides
    @Singleton
    fun provideTaskRepository(): TaskRepository {
        return InMemoryTaskRepository()
    }
}