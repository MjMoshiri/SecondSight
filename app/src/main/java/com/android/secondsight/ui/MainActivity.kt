@file:OptIn(ExperimentalMaterial3Api::class)

package com.android.secondsight.ui

import android.Manifest.permission.POST_NOTIFICATIONS
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.android.secondsight.ui.theme.SecondSightTheme
import com.android.secondsight.viewmodel.TaskListViewModel
import com.android.secondsight.viewmodel.provider.ViewModelProvider
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    private val viewModel: TaskListViewModel by viewModels()

    @Inject
    lateinit var ViewModelProvider: ViewModelProvider

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val darkTheme =
                remember { mutableStateOf(false) }
            if (ContextCompat.checkSelfPermission(this, POST_NOTIFICATIONS) == PackageManager.PERMISSION_DENIED) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    ActivityCompat.requestPermissions(this, arrayOf(POST_NOTIFICATIONS), 1)
                }
            }


            SecondSightTheme(darkTheme = darkTheme.value) {
                SecondSight(
                    viewModel, ViewModelProvider, darkTheme = darkTheme
                )
            }
        }

    }

}

