package com.android.secondsight.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.android.secondsight.util.ui.getDurationString
import com.android.secondsight.viewmodel.EntryViewModel


@Composable
fun EntryScreen(
    viewModel: EntryViewModel, pd: PaddingValues, stopEntry: (Long) -> Unit
) {
    val taskEntry = viewModel.taskEntry.observeAsState()
    val duration by viewModel.time.observeAsState()
    val isComplete by viewModel.isCompleted.observeAsState()
    var showDialog by remember { mutableStateOf(false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(pd),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = getDurationString(duration),
            textAlign = TextAlign.Center,
            modifier = Modifier.align(Alignment.Center)
        )
        Button( // Delete button
            onClick = { showDialog = true },
            modifier = Modifier.align(Alignment.TopStart)
        ) {
            Text(text = "Delete")
        }
        if (showDialog) {
            AlertDialog(
                onDismissRequest = { showDialog = false },
                title = { Text("Delete Task") },
                text = { Text("Are you sure you want to delete this task?") },
                confirmButton = {
                    Button(onClick = {
                        viewModel.deleteTaskEntry()
                        stopEntry(taskEntry.value?.id!!)
                        showDialog = false
                    }) {
                        Text("Yes")
                    }
                },
                dismissButton = {
                    Button(onClick = { showDialog = false }) {
                        Text("No")
                    }
                }
            )
        }
    }
    if (isComplete == false) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.Bottom,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row {
                Button(modifier = Modifier
                    .weight(1f)
                    .padding(end = 8.dp), onClick = {
                    if (taskEntry.value?.isRunning == true) {
                        viewModel.pauseTaskEntry()
                    } else {
                        viewModel.resumeTaskEntry()
                    }
                }) {
                    Text(
                        text = if (taskEntry.value?.isRunning == true) "Pause" else "Resume"
                    )
                }
                Button(modifier = Modifier
                    .weight(1f)
                    .padding(start = 8.dp), onClick = {
                    viewModel.endTaskEntry()
                    stopEntry(taskEntry.value?.id!!)
                }) {
                    Text(text = "Stop")
                }
            }
        }
    }

}
