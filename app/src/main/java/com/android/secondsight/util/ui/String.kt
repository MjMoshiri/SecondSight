package com.android.secondsight.util.ui
import java.time.Duration

fun getDurationString(duration: Duration?) = duration?.let {
    String.format(
        "%02d:%02d:%02d:%02d" + "",
        it.toHours(),
        it.toMinutes() % 60,
        it.seconds % 60,
        it.toMillis() % 1000 / 10
    )
} ?: "00:00:00:00"