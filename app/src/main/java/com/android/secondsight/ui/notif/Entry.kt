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


class EntryNotificationService(private val context: Context) {

    companion object {
        const val CHANNEL_ID = "com.android.secondsight.EntryNotificationService"
    }

    private val notificationManager: NotificationManager by lazy {
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    init {
        createNotificationChannel()
    }

    fun show(id: Long, isRunning: Boolean?) {
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.timer)
            .setContentTitle("Task Entry Notification")
            .setContentText("Manage your task entry $id")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .addAction(createStopAction(id))
            .addAction(if (isRunning == false) createResumeAction(id) else createPauseAction(id))
            .setDeleteIntent(createDeleteIntent(id))
            .setAutoCancel(true)
            .build()

        notificationManager.notify(id.toInt(), notification)
    }

    fun stop(id: Long) {
        notificationManager.cancel(id.toInt())
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID, "Task Entry Channel", NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Channel for Task Entry Notification"
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createDeleteIntent(id: Long): PendingIntent {
        val intent = Intent(context, Receiver::class.java)
        intent.action = "action.delete!$id"
        return PendingIntent.getBroadcast(context, id.toInt(), intent, PendingIntent.FLAG_IMMUTABLE)
    }

    private fun createPauseAction(id: Long): NotificationCompat.Action {
        val intent = Intent(context, Receiver::class.java).apply {
            action = "action.pause!$id"
        }
        val pendingIntent = PendingIntent.getBroadcast(context, id.toInt(), intent, PendingIntent.FLAG_IMMUTABLE)
        return NotificationCompat.Action(R.drawable.ic_pause, "Pause", pendingIntent)
    }

    private fun createResumeAction(id: Long): NotificationCompat.Action {
        val intent = Intent(context, Receiver::class.java).apply {
            action = "action.resume!$id"
        }
        val pendingIntent = PendingIntent.getBroadcast(context, id.toInt(), intent, PendingIntent.FLAG_IMMUTABLE)
        return NotificationCompat.Action(R.drawable.ic_play, "Resume", pendingIntent)
    }

    private fun createStopAction(id: Long): NotificationCompat.Action {
        val intent = Intent(context, Receiver::class.java).apply {
            action = "action.stop!$id"
        }
        val pendingIntent = PendingIntent.getBroadcast(context, id.toInt(), intent, PendingIntent.FLAG_IMMUTABLE)
        return NotificationCompat.Action(R.drawable.ic_stop, "Stop", pendingIntent)
    }
}

