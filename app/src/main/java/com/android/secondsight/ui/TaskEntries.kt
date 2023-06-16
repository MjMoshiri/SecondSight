package com.android.secondsight.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.android.secondsight.data.TaskEntry
import com.android.secondsight.util.ui.getDurationString
import com.android.secondsight.viewmodel.TaskViewModel
import java.time.format.DateTimeFormatter

@Composable
fun EntryListScreen(
    viewModel: TaskViewModel,
    pd: PaddingValues,
    createEntry: (Long) -> Unit,
    selectEntry: (Long) -> Unit
) {
    val entries = viewModel.taskEntries.observeAsState()
    LaunchedEffect(key1 = viewModel.taskEntries) {
        viewModel.updateTaskEntry()
    }
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(pd)
    ) {
        Column {
            EntryList(
                entries = entries.value?.entries ?: emptyList(), selectEntry = selectEntry
            )
        }
        FloatingActionButton(
            onClick = {
               viewModel.addTaskEntry(createEntry)
            }, modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.PlayArrow, contentDescription = "Start Task",
            )
        }
    }
}

@Composable
fun EntryList(
    entries: List<TaskEntry>, selectEntry: (Long) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
    ) {
        items(entries) { entry ->
            EntryItem(entry = entry, selectEntry)
        }
    }
}

@Composable
fun EntryItem(entry: TaskEntry, selectEntry: (Long) -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable {
                selectEntry(entry.id)
            }, horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(text = entry.start.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
        Text(text = getDurationString(entry.duration))
    }
}



