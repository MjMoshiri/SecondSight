package com.android.secondsight.data.repository

import com.android.secondsight.data.Task

interface TaskRepository {
    fun getTasks(): List<Task>
    fun getTask(id: String): Task
    fun addTask(name: String, description: String? = ""): Task
    fun updateTask(name: String? = null, description: String? = null, task: Task): Task
    fun deleteTask(task: Task)
}