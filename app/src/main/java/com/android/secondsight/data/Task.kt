package com.android.secondsight.data



// Represents a single task that you want to track time for.
data class Task(
    val name: String,
    val description: String? = "",
    val id : String
)
