package com.android.secondsight.data

import java.time.Duration
import java.time.LocalDateTime

// Represents a specific period of time spent on a task.
data class Interval(
    val start: LocalDateTime,
    val end: LocalDateTime,
    val duration: Duration,
)
