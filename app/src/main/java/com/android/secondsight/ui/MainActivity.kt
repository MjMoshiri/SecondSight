@file:OptIn(ExperimentalMaterial3Api::class)

package com.android.secondsight.ui

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material3.ExperimentalMaterial3Api
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
            SecondSight(
                viewModel,
                vmProvider
            )
        }
    }
}

