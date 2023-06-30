package com.android.secondsight.util

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.annotation.CallSuper
import com.android.secondsight.data.repository.TaskEntryRepository
import com.android.secondsight.ui.notif.EntryNotificationService
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class Receiver : HiltBroadcastReceiver() {
    @Inject
    lateinit var taskEntryRepository: TaskEntryRepository
    @Inject
    lateinit var notificationManager: EntryNotificationService
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        val action = intent.action!!.substringBeforeLast("!")
        val entryId = intent.action!!.substringAfterLast("!").toLong()

        when (action) {
            "action.pause" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    taskEntryRepository.pauseTaskEntry(entryId)
                    notificationManager.show(entryId, false)
                }
            }

            "action.resume" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    taskEntryRepository.resumeTaskEntry(entryId)
                    notificationManager.show(entryId, true)
                }
            }

            "action.stop" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    taskEntryRepository.endTaskEntry(entryId)
                    notificationManager.stop(entryId)
                }
            }

            "action.delete" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    notificationManager.stop(entryId)
                }
            }

            else -> println("Unknown action")
        }
    }
}

abstract class HiltBroadcastReceiver : BroadcastReceiver() {
    @CallSuper
    override fun onReceive(context: Context, intent: Intent) {
    }
}