package com.android.secondsight.ui.notif

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.android.secondsight.R
import com.android.secondsight.util.Receiver


class EntryNotificationService(
    private val context: Context, private val id: Long, private val isRunning: Boolean?,
) {

    companion object {
        const val CHANNEL_ID = "entry_notif_channel"
        const val NOTIF_ID = 1
    }

    private val notificationManager: NotificationManager by lazy {
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    init {
        createNotificationChannel()
    }

    fun show() {
        val notification =
            NotificationCompat.Builder(context, CHANNEL_ID).setSmallIcon(R.drawable.timer)
                .setContentTitle("Task Entry Notification").setContentText("Manage your task entry")
                .setPriority(NotificationCompat.PRIORITY_HIGH).setOngoing(true)
                .addAction(createStopAction())
                .addAction(if (isRunning == false) createResumeAction() else createPauseAction())
                .build()

        notificationManager.notify(NOTIF_ID, notification)
    }

    fun stop() {
        notificationManager.cancel(NOTIF_ID)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID, "Task Entry Channel", NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Channel for Task Entry Notification"
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createPauseAction(): NotificationCompat.Action {
        val intent = Intent(context, Receiver::class.java).apply {
            action = "action.pause"
            putExtra("entryId", id)
        }
        val pendingIntent =
            PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
        return NotificationCompat.Action(
            R.drawable.ic_pause, "Pause", pendingIntent
        )
    }

    private fun createResumeAction(): NotificationCompat.Action {
        val intent = Intent(context, Receiver::class.java).apply {
            action = "action.resume"
            putExtra("entryId", id)
        }
        val pendingIntent =
            PendingIntent.getBroadcast(
                context,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE
            )
        return NotificationCompat.Action(
            R.drawable.ic_play, "Resume", pendingIntent
        )
    }

    private fun createStopAction(): NotificationCompat.Action {
        val intent = Intent(context, Receiver::class.java).apply {
            action = "action.stop"
            putExtra("entryId", id)
        }
        val pendingIntent =
            PendingIntent.getBroadcast(
                context,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE
            )
        return NotificationCompat.Action(
            R.drawable.ic_stop, "Stop", pendingIntent
        )
    }
}
