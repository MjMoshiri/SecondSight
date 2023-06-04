package com.android.secondsight.data.repository.dummy

import com.android.secondsight.data.Task
import com.android.secondsight.data.repository.TaskRepository

class InMemoryTaskRepository : TaskRepository {
    private val tasks = mutableListOf<Task>()
    private var currentId = 0
    override fun getTasks(): List<Task> {
        return tasks
    }

    override fun getTask(id: String): Task {
        return tasks.find { it.id == id }
            ?: throw NoSuchElementException("Can't find the Task")
    }

    override fun addTask(name: String, description: String?): Task {
        val task = Task(name, description, currentId++.toString())
        tasks.add(task)
        return task
    }

    override fun updateTask(name: String?, description: String?, task: Task): Task {
        val index = tasks.indexOf(task)
        if (index == -1) {
            throw NoSuchElementException("Can't find the Task")
        }
        tasks[index] =
            task.copy(name = name ?: task.name, description = description ?: task.description)
        return tasks[index]
    }

    override fun deleteTask(task: Task) {
        tasks.remove(task)
    }
}