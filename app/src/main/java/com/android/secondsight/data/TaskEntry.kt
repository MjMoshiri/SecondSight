package com.android.secondsight.data

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey
import androidx.room.TypeConverters
import com.android.secondsight.util.TypeConverter
import java.time.Duration
import java.time.LocalDateTime

// Represents a specific instance of time tracking for a task. This might include multiple intervals if you pause and resume tracking.
@Entity(
    foreignKeys = [ForeignKey(
        entity = Task::class,
        parentColumns = ["id"],
        childColumns = ["taskId"],
        onDelete = ForeignKey.CASCADE
    )]
)
@TypeConverters(TypeConverter::class)
data class TaskEntry(
    @PrimaryKey(autoGenerate = true) val id: Long,
    val taskId: Long,
    val start: LocalDateTime,
    val end: LocalDateTime?,
    val curStart: LocalDateTime?,
    val intervals: List<Interval>?,
    val duration: Duration,
    val isRunning: Boolean?,
    val isComplete: Boolean
)