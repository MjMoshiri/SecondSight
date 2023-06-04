package com.android.secondsight.data

import kotlin.time.Duration
import kotlin.time.TimeSource

// Represents a specific instance of time tracking for a task. This might include multiple intervals if you pause and resume tracking.
data class TaskEntry(
    val id: String,
    val taskId: String,
    val start: TimeSource.Monotonic.ValueTimeMark?,
    val end: TimeSource.Monotonic.ValueTimeMark?,
    val curStart: TimeSource.Monotonic.ValueTimeMark?,
    val intervals: List<Interval>?,
    val duration: Duration?,
    val isRunning: Boolean?,
    val isComplete: Boolean
)