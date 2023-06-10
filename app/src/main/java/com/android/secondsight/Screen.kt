package com.android.secondsight

enum class Screen(val route: String) {
    TaskList("task_list"), TaskDetail("task_detail/{taskId}"), Entry("task_detail/{taskId}/entry_detail/{entryId}");
}