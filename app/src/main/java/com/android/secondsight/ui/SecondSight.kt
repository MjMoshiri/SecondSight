package com.android.secondsight.ui

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material3.Divider
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.android.secondsight.Screen
import com.android.secondsight.ui.util.ThemeSwitcher
import com.android.secondsight.viewmodel.TaskListViewModel
import com.android.secondsight.viewmodel.provider.vmProvider
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SecondSight(
    viewModel: TaskListViewModel,
    vmProvider: vmProvider,
    navController: NavHostController = rememberNavController(),
    darkTheme: MutableState<Boolean>
) {
    val backStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = backStackEntry?.destination?.route
    val drawerState = rememberDrawerState(DrawerValue.Closed)
    val scope = rememberCoroutineScope()

    ModalNavigationDrawer(drawerState = drawerState,
        gesturesEnabled = drawerState.isOpen,
        drawerContent = {
            ModalDrawerSheet {
                Text("Theme", modifier = Modifier.padding(16.dp))
                Divider()
                Row(
                    modifier = Modifier
                        .padding(16.dp)
                        .fillMaxWidth()
                ) {
                    Spacer(modifier = Modifier.weight(1f))
                    ThemeSwitcher(size = 50.dp, darkTheme = darkTheme.value, onClick = {
                        darkTheme.value = !darkTheme.value
                    })
                }
            }
        },
        content = {
            Scaffold(topBar = {
                TopAppBar(title = {
                    Text(
                        text = when (currentRoute) {
                            Screen.TaskList.route -> "Tasks"
                            Screen.TaskDetail.route -> "Entries"
                            Screen.Entry.route -> "Entry"
                            else -> "Second Sight"
                        }
                    )
                }, actions = {
                    IconButton(onClick = {
                        scope.launch {
                            if (drawerState.isOpen) drawerState.close() else drawerState.open()
                        }
                    }) {
                        Icon(Icons.Filled.Menu, contentDescription = "Menu")
                    }
                })
            }) { innerPadding ->
                NavHost(navController = navController, startDestination = "task_list") {
                    composable("task_list") {
                        TaskListScreen(viewModel, pd = innerPadding, onTaskClick = { taskId ->
                            navController.navigate("task_detail/$taskId")
                        })
                    }
                    composable("task_detail/{taskId}") {
                        val taskId = it.arguments?.getString("taskId")!!.toLong()
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
                        val entryId = it.arguments?.getString("entryId")!!.toLong()
                        EntryScreen(viewModel = vmProvider.getEntryViewModel(entryId),
                            pd = innerPadding,
                            stopEntry = { taskId ->
                                navController.popBackStack("task_detail/$taskId", false)
                            })
                    }
                }
            }
        })
}





