@file:OptIn(ExperimentalMaterial3Api::class)

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
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.android.secondsight.data.Task
import com.android.secondsight.viewmodel.TaskListViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TaskListScreen(
    viewModel: TaskListViewModel,
    pd: PaddingValues,
    onTaskClick: (String) -> Unit,
) {
    val tasks by viewModel.tasks.observeAsState(listOf())
    val newTaskDialogShown = remember { mutableStateOf(false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(pd)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            TaskList(tasks = tasks, onTaskClick = onTaskClick)
        }
        FloatingActionButton(
            onClick = { newTaskDialogShown.value = true },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Add, contentDescription = "Add Task"
            )
        }
        if (newTaskDialogShown.value) {
            NewTaskDialog(onConfirm = { name, description ->
                viewModel.addTask(name, description)
                newTaskDialogShown.value = false
            }, onCancel = { newTaskDialogShown.value = false })
        }
    }
}

@Composable
fun TaskList(tasks: List<Task>, onTaskClick: (String) -> Unit) {
    LazyColumn(
        modifier = Modifier.fillMaxWidth()
    ) {
        items(tasks) { task ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable {
                        onTaskClick(task.id)
                    }, horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text(text = task.name)
                    task.description?.let { description ->
                        Text(text = description)
                    }
                }
            }
        }
    }
}



