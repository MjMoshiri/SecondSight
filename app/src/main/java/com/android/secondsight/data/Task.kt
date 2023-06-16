package com.android.secondsight.data

import androidx.room.Entity
import androidx.room.PrimaryKey


// Represents a single task that you want to track time for.
@Entity
data class Task(
    val name: String,
    val description: String? = "",
    @PrimaryKey(autoGenerate = true)
    val id: Long
)
