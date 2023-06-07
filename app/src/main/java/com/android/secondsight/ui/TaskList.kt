@file:OptIn(ExperimentalMaterial3Api::class)

package com.android.secondsight.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.unit.dp
import com.android.secondsight.data.Task
import com.android.secondsight.viewmodel.TaskListViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TaskListScreen(viewModel: TaskListViewModel, pd: PaddingValues) {
    val tasks by viewModel.tasks.observeAsState(listOf())
    val newTaskDialogShown = remember { mutableStateOf(false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(pd)
    ) {
        Column(modifier = Modifier.fillMaxWidth()) {
            TaskList(tasks = tasks)
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
fun TaskList(tasks: List<Task>) {
    LazyColumn(
        modifier = Modifier.fillMaxWidth()
    ) {
        items(tasks) { task ->
            Row(
                modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween
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

@Composable
fun NewTaskDialog(onConfirm: (String, String) -> Unit, onCancel: () -> Unit) {
    var name by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }
    var isError by remember { mutableStateOf(false) }

    AlertDialog(onDismissRequest = onCancel, title = { Text(text = "New Task") }, text = {
        Column {
            OutlinedTextField(modifier = Modifier
                .fillMaxWidth()
                .onFocusChanged { focusState ->
                    if (focusState.isFocused) {
                        isError = false
                    }
                },
                shape = RoundedCornerShape(8.dp),
                value = name,
                onValueChange = { name = it },
                isError = isError,
                singleLine = true,
                label = { Text(text = "Name") })
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(value = description,
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                onValueChange = { description = it },
                label = { Text(text = "Description") })
        }
    }, confirmButton = {
        Button(onClick = {
            if (name.isNotBlank()) {
                onConfirm(name, description)
            } else {
                isError = true
            }
        }) {
            Text(text = "Add")
        }
    }, dismissButton = {
        Button(onClick = onCancel) {
            Text(text = "Cancel")
        }
    })
}

