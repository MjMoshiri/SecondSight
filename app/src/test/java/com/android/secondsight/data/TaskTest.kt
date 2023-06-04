package com.android.secondsight.data

import com.android.secondsight.data.repository.dummy.InMemoryTaskRepository
import org.junit.Before
import org.junit.Test

class TaskTest {
    private var TaskRepository = InMemoryTaskRepository()

    @Before
    fun setUp() {
        TaskRepository = InMemoryTaskRepository()
    }

    @Test
    fun testAddTaskWithNameOnly() {
        // task is added to the repository
        val task = TaskRepository.addTask("testTask")
    }

    @Test
    fun testAddTaskWithNameAndDescription() {
        // task is added to the repository
        val task = TaskRepository.addTask("testTask", "testDescription")
    }

    @Test
    fun testGetTask() {
        // when a task is created
        val task = TaskRepository.addTask("testTask", "testDescription")
        // then the task is added to the repository
        assert(task.id == TaskRepository.getTask(task.id).id)
        // and the task has a name
        assert(task.name == "testTask")
        // and the task has a description
        assert(task.description == "testDescription")
    }

    @Test
    fun testUpdateTaskName() {
        val task = TaskRepository.addTask("testTask", "testDescription")
        assert(task.id == TaskRepository.getTask(task.id).id)
        // when the task name is updated
        val updatedTask = TaskRepository.updateTask("updatedTask", task = task)
        // then the task name is updated
        assert(updatedTask.name == "updatedTask")
        // and the task description is the same
        assert(updatedTask.description == "testDescription")
    }

    @Test
    fun testUpdateTaskDescription() {
        val task = TaskRepository.addTask("testTask", "testDescription")
        assert(task.id == TaskRepository.getTask(task.id).id)
        // when the task description is updated
        val updatedTask = TaskRepository.updateTask(description = "updatedDescription", task = task)
        // then the task name is the same
        assert(updatedTask.name == "testTask")
        // and the task description is updated
        assert(updatedTask.description == "updatedDescription")
    }

    @Test
    fun testDeleteTask() {
        val task = TaskRepository.addTask("testTask", "testDescription")
        assert(task.id == TaskRepository.getTask(task.id).id)
        // when the task is deleted
        TaskRepository.deleteTask(task)
        // then the task is removed from the repository
        try {
            TaskRepository.getTask(task.id)
            assert(false)
        } catch (e: NoSuchElementException) {
            assert(true)
        }
    }
}