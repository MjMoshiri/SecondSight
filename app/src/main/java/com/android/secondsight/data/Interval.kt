package com.android.secondsight.data

import kotlin.time.Duration
import kotlin.time.TimeSource

// Represents a specific period of time spent on a task.
data class Interval(
    val start: TimeSource.Monotonic.ValueTimeMark,
    val end: TimeSource.Monotonic.ValueTimeMark,
    val duration: Duration,
    val id: String,
)
