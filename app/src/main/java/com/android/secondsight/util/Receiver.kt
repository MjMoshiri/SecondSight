package com.android.secondsight.util

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.annotation.CallSuper
import com.android.secondsight.viewmodel.provider.vmProvider
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class Receiver : HiltBroadcastReceiver() {
    @Inject
    lateinit var vmProvider: vmProvider
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        val action = intent.action!!.substringBeforeLast("!")
        val entryId = intent.action!!.substringAfterLast("!").toLong()
        val entryViewModel = vmProvider.getEntryViewModel(entryId)
        when (action) {
            "action.pause" -> {
                entryViewModel.pauseTaskEntry()
            }

            "action.resume" -> {
                entryViewModel.resumeTaskEntry()
            }

            "action.stop" -> {
                entryViewModel.endTaskEntry()
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