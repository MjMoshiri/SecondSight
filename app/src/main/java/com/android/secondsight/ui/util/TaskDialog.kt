package com.android.secondsight.ui.util

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CreateOrUpdateTaskDialog(
    onConfirm: (String, String) -> Unit,
    onCancel: () -> Unit,
    initialName: String,
    initialDescription: String
) {
    var name by remember { mutableStateOf(initialName) }
    var description by remember { mutableStateOf(initialDescription) }
    var isError by remember { mutableStateOf(false) }

    AlertDialog(onDismissRequest = onCancel, title = { Text(text = "Update Task") }, text = {
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
            Text(text = let {
                if (initialName.isNotBlank()) {
                    "Update"
                } else {
                    "Create"
                }
            })
        }
    }, dismissButton = {
        Button(onClick = onCancel) {
            Text(text = "Cancel")
        }
    })
}

