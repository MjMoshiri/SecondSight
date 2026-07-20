package com.mjmoshiri.secondsight

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

private const val MAX_ROWS = 5

class GoalsWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val goals = JSONArray(widgetData.getString("goals", null) ?: "[]")
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_goals)
            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )

            var runningCount = 0
            for (i in 0 until MAX_ROWS) {
                val rowId = id(context, "goal_row_$i")
                if (i >= goals.length()) {
                    views.setViewVisibility(rowId, View.GONE)
                    continue
                }
                val goal = goals.getJSONObject(i)
                views.setViewVisibility(rowId, View.VISIBLE)
                if (goal.getBoolean("running")) runningCount++
                bindRow(context, views, i, goal)
            }

            views.setViewVisibility(
                R.id.widget_empty,
                if (goals.length() == 0) View.VISIBLE else View.GONE,
            )
            views.setTextViewText(
                R.id.widget_running,
                if (runningCount > 0) "$runningCount running" else "",
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun bindRow(context: Context, views: RemoteViews, i: Int, goal: org.json.JSONObject) {
        val goalId = goal.getString("id")
        val running = goal.getBoolean("running")
        val paused = goal.getBoolean("paused")

        views.setTextViewText(id(context, "goal_name_$i"), goal.getString("name"))

        val timerId = id(context, "goal_timer_$i")
        val statusId = id(context, "goal_status_$i")
        if (running) {
            // Chronometer ticks natively; base accounts for time since the
            // data was written plus whatever the timer had accumulated.
            val elapsed = goal.getLong("elapsedMs") +
                (System.currentTimeMillis() - goal.getLong("writtenAtUtc"))
            views.setViewVisibility(timerId, View.VISIBLE)
            views.setViewVisibility(statusId, View.GONE)
            views.setChronometer(timerId, SystemClock.elapsedRealtime() - elapsed, null, true)
        } else {
            views.setViewVisibility(timerId, View.GONE)
            views.setViewVisibility(statusId, View.VISIBLE)
            views.setTextViewText(statusId, goal.getString("status"))
        }

        val barId = id(context, "goal_bar_$i")
        val barPath = goal.optString("bar", "")
        val bitmap = if (barPath.isNotEmpty()) BitmapFactory.decodeFile(barPath) else null
        if (bitmap != null) {
            views.setViewVisibility(barId, View.VISIBLE)
            views.setImageViewBitmap(barId, bitmap)
        } else {
            views.setViewVisibility(barId, View.GONE)
        }

        val toggleId = id(context, "goal_toggle_$i")
        val stopId = id(context, "goal_stop_$i")
        val toggleAction = if (running) "pause" else if (paused) "resume" else "start"
        views.setImageViewResource(
            toggleId,
            if (running) R.drawable.ic_widget_pause else R.drawable.ic_widget_play,
        )
        views.setOnClickPendingIntent(toggleId, actionIntent(context, toggleAction, goalId))
        views.setViewVisibility(stopId, if (running || paused) View.VISIBLE else View.GONE)
        views.setOnClickPendingIntent(stopId, actionIntent(context, "stop", goalId))
    }

    private fun actionIntent(context: Context, action: String, goalId: String) =
        HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("secondsight://timer?action=$action&goalId=$goalId"),
        )

    private fun id(context: Context, name: String) =
        context.resources.getIdentifier(name, "id", context.packageName)
}
