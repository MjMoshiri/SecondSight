package com.android.secondsight.data

import com.android.secondsight.data.repository.dummy.InMemoryTaskEntryRepository
import org.junit.Before
import org.junit.Test

class TaskEntryTest {
    private val task = Task("testTask", "testDescription", "testId")
    private var taskEntryRepository = InMemoryTaskEntryRepository()

    @Before
    fun setUp() {
        taskEntryRepository = InMemoryTaskEntryRepository()
    }

    @Test
    fun testAddTaskEntry() {
        // task entry is added to the repository
        val taskEntry = taskEntryRepository.addTaskEntry(task.id)
    }

    @Test
    fun testGetTaskEntry() {
        // when a task entry is created
        val taskEntry = taskEntryRepository.addTaskEntry(task.id)
        // then the task entry is added to the repository
        assert(taskEntry.id == taskEntryRepository.getTaskEntry(taskEntry.id).id)
    }

    @Test
    fun testPauseTaskEntry() {
        val taskEntry = taskEntryRepository.addTaskEntry(task.id)
        // when a task entry is paused
        val pausedTaskEntry = taskEntryRepository.pauseTaskEntry(taskEntry.id)
        // then the task entry is not running
        assert(pausedTaskEntry.isRunning == false)
        // and the task entry has a duration
        assert(pausedTaskEntry.duration != null)
        // and the task entry has an interval
        assert(pausedTaskEntry.intervals!!.size == 1)
    }

    @Test
    fun testResumeTaskEntry() {
        val taskEntry = taskEntryRepository.addTaskEntry(task.id)
        val pausedTaskEntry = taskEntryRepository.pauseTaskEntry(taskEntry.id)
        // when the task entry is resumed
        val resumedTaskEntry = taskEntryRepository.resumeTaskEntry(pausedTaskEntry.id)
        // then the task entry is running
        assert(resumedTaskEntry.isRunning == true)
        // and the task entry has a duration
        assert(resumedTaskEntry.duration != null)
        // and the task entry has an interval
        assert(resumedTaskEntry.intervals!!.size == 1)
    }

    @Test
    fun testEndTaskEntry() {
        val taskEntry = taskEntryRepository.addTaskEntry(task.id)
        // when the task entry is ended
        val endedTaskEntry = taskEntryRepository.endTaskEntry(taskEntry.id)
        // then the task is complete
        assert(endedTaskEntry.isComplete)
        // then the task entry is not running
        assert(endedTaskEntry.isRunning == false)
        // and the task entry has a duration
        assert(endedTaskEntry.duration != null)
        // and the task entry has an interval
        assert(endedTaskEntry.intervals!!.size == 1)
    }

}