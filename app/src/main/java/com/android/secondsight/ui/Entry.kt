package com.android.secondsight.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
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
    val taskEntry by viewModel.taskEntry.collectAsState()
    val duration by viewModel.time.collectAsState()
    val isComplete by viewModel.isCompleted.collectAsState()

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
                    if (taskEntry?.isRunning == true) {
                        viewModel.pauseTaskEntry()
                    } else {
                        viewModel.resumeTaskEntry()
                    }
                }) {
                    Text(
                        text = if (taskEntry?.isRunning == true) "Pause" else "Resume"
                    )
                }
                Button(modifier = Modifier
                    .weight(1f)
                    .padding(start = 8.dp), onClick = {
                    viewModel.endTaskEntry()
                    taskEntry?.id?.let { stopEntry(it) }
                }) {
                    Text(text = "Stop")
                }
            }
        }
    }
}
