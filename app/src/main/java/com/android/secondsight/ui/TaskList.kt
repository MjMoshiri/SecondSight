package com.android.secondsight.ui

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import com.android.secondsight.viewmodel.TaskListViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TaskListScreen(viewModel: TaskListViewModel) {
    var taskName by remember { mutableStateOf("") }
    var taskDescription by remember { mutableStateOf("") }
    val tasks by viewModel.tasks.observeAsState(listOf())

    Column {
        LazyColumn {
            items(tasks) { task ->
                Text(text = task.name)
                task.description?.let { description ->
                    Text(text = description)
                }
                Button(onClick = { viewModel.deleteTask(task) }) {
                    Text("Delete")
                }
            }
        }
        TextField(value = taskName,
            onValueChange = { taskName = it },
            label = { Text("Task Name") })
        TextField(value = taskDescription,
            onValueChange = { taskDescription = it },
            label = { Text("Task Description") })
        Button(onClick = {
            viewModel.addTask(taskName, taskDescription)
            taskName = ""
            taskDescription = ""
        }) {
            Text("Add Task")
        }
    }
}

