package com.android.secondsight.data

import java.time.Duration
import java.time.LocalDateTime
import kotlin.time.ExperimentalTime

// Represents a specific instance of time tracking for a task. This might include multiple intervals if you pause and resume tracking.
@OptIn(ExperimentalTime::class)
data class TaskEntry(
    val id: String,
    val taskId: String,
    val start: LocalDateTime,
    val end: LocalDateTime?,
    val curStart: LocalDateTime?,
    val intervals: List<Interval>?,
    val duration: Duration,
    val isRunning: Boolean?,
    val isComplete: Boolean
)