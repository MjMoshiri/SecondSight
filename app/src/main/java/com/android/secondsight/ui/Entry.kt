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
import androidx.compose.runtime.LaunchedEffect
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
    viewModel: EntryViewModel,
    pd: PaddingValues,
    stopEntry: (Long) -> Unit,
) {
    LaunchedEffect(true) {
        viewModel.setNotif()
    }
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(pd), contentAlignment = Alignment.Center
    ) {
        DurationDisplay(viewModel)
    }
    ControlPanel(
        viewModel, stopEntry
    )
}

@Composable
fun DurationDisplay(viewModel: EntryViewModel) {
    val duration by viewModel.time.collectAsState()
    Text(
        text = getDurationString(duration),
        textAlign = TextAlign.Center,
    )
}

@Composable
fun ControlPanel(
    viewModel: EntryViewModel,
    stopEntry: (Long) -> Unit,
) {
    val isComplete by viewModel.isComplete.collectAsState()
    val isRunning by viewModel.isRunning.collectAsState()

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
                    if (isRunning == true) {
                        viewModel.pauseTaskEntry()
                    } else {
                        viewModel.resumeTaskEntry()
                    }
                }) {
                    Text(
                        text = if (isRunning == true) "Pause" else "Resume"
                    )
                }
                Button(modifier = Modifier
                    .weight(1f)
                    .padding(start = 8.dp), onClick = {
                    viewModel.endTaskEntry()
                    stopEntry(viewModel.entryId)
                }) {
                    Text(text = "Stop")
                }
            }
        }
    }
}