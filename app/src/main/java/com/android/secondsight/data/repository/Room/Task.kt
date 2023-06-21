package com.android.secondsight.data.repository.Room

import com.android.secondsight.data.Task
import com.android.secondsight.data.dao.TaskDao
import com.android.secondsight.data.repository.TaskRepository
import javax.inject.Inject

class RoomTaskRepository @Inject constructor(
    private val taskDao: TaskDao
) : TaskRepository {
    override fun getTasks(): List<Task> {
        return taskDao.getTasks()
    }

    override fun getTask(id: Long): Task {
        return taskDao.getTask(id)
    }

    override fun addTask(name: String, description: String?): Task {
        val task = Task(name = name, description = description, id = 0)
        val id = taskDao.addTask(task)
        return task.copy(id = id)
    }

    override fun updateTask(name: String?, description: String?, task: Task): Task {
        val updatedTask = task.copy(
            name = name ?: task.name, description = description ?: task.description
        )
        taskDao.updateTask(updatedTask)
        return updatedTask
    }

    override fun deleteTask(task: Task) {
        taskDao.deleteTask(task)
    }
}