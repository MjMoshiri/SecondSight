@file:OptIn(ExperimentalMaterial3Api::class)

package com.android.secondsight.ui

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import com.android.secondsight.ui.theme.SecondSightTheme
import com.android.secondsight.viewmodel.TaskListViewModel
import com.android.secondsight.viewmodel.provider.vmProvider
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    private val viewModel: TaskListViewModel by viewModels()

    @Inject
    lateinit var vmProvider: vmProvider


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val darkTheme = remember { mutableStateOf(false) } // false means light theme is active, true means dark theme is active

            SecondSightTheme(darkTheme = darkTheme.value) {
                SecondSight(
                    viewModel,
                    vmProvider,
                    darkTheme = darkTheme
                )
            }
        }
    }

}

