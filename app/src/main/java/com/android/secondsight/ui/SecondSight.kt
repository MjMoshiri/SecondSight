package com.android.secondsight.ui

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.android.secondsight.Screen
import com.android.secondsight.viewmodel.TaskListViewModel
import com.android.secondsight.viewmodel.provider.vmProvider

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SecondSight(
    viewModel: TaskListViewModel,
    vmProvider: vmProvider,
    navController: NavHostController = rememberNavController()
) {
    val backStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = backStackEntry?.destination?.route

    Scaffold(
        topBar = {
            TopAppBar(title = {
                Text(
                    text = when (currentRoute) {
                        Screen.TaskList.route -> "Tasks"
                        Screen.TaskDetail.route -> "Entries"
                        Screen.Entry.route -> "Entry"
                        else -> "Second Sight"
                    }
                )
            })
        },
    ) { innerPadding ->
        NavHost(navController = navController, startDestination = "task_list") {
            composable("task_list") {
                TaskListScreen(viewModel, pd = innerPadding, onTaskClick = { taskId ->
                    navController.navigate("task_detail/$taskId")
                })
            }
            composable("task_detail/{taskId}") {
                val taskId = it.arguments?.getString("taskId")!!
                EntryListScreen(viewModel = vmProvider.getTaskViewModel(taskId),
                    pd = innerPadding,
                    createEntry = { entryId ->
                        navController.navigate("task_detail/$taskId/entry_detail/$entryId")
                    },
                    selectEntry = { entryId ->
                        navController.navigate("task_detail/$taskId/entry_detail/$entryId")
                    })
            }
            composable("task_detail/{taskId}/entry_detail/{entryId}") {
                val entryId = it.arguments?.getString("entryId")!!
                EntryScreen(viewModel = vmProvider.getEntryViewModel(entryId),
                    pd = innerPadding,
                    stopEntry = { navController.popBackStack() })
            }
        }
    }
}



