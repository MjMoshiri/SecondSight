package com.android.secondsight.data

import java.util.UUID
import kotlin.time.Duration
import kotlin.time.TimeSource

// Represents a specific instance of time tracking for a task. This might include multiple intervals if you pause and resume tracking.
data class TaskEntry(
    val id: UUID,
    val taskId: UUID,
    val start: TimeSource,
    val end: TimeSource,
    val intervals: List<Interval>,
    val duration: Duration,
    val isRunning: Boolean,
    val isComplete: Boolean
)