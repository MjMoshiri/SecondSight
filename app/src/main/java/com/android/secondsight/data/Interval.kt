package com.android.secondsight.data

import java.time.Duration
import java.time.LocalDateTime
import kotlin.time.ExperimentalTime

// Represents a specific period of time spent on a task.
@OptIn(ExperimentalTime::class)
data class Interval(
    val start: LocalDateTime,
    val end: LocalDateTime,
    val duration: Duration,
    val id: String,
)
