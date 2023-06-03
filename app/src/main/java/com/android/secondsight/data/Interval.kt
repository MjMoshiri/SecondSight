package com.android.secondsight.data

import kotlin.time.Duration
import kotlin.time.TimeSource
// Represents a specific period of time spent on a task.
data class Interval(
    val start: TimeSource,
    val end: TimeSource,
    val duration: Duration,
    val id : String ,
)
