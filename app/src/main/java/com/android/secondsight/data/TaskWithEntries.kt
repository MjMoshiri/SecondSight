package com.android.secondsight.data

import androidx.room.Embedded
import androidx.room.Relation

data class TaskWithEntries(
    @Embedded val task: Task, @Relation(
        parentColumn = "id", entityColumn = "taskId"
    ) val entries: List<TaskEntry>
)
