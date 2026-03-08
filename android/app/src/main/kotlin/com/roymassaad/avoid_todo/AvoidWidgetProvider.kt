package com.roymassaad.avoid_todo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Android home-screen widget.
 *
 * Tap behaviour:
 *   - Main area  → cycle through active habits (broadcast → onReceive → rebuild)
 *   - ↗ icon     → open the app
 *
 * SharedPreferences keys (written by Flutter via HomeWidget.saveWidgetData):
 *   habit_count          Int    total active habits (for the label)
 *   widget_item_count    Int    how many indexed habits are stored (≤ 10)
 *   widget_current_index Int    which habit is currently shown
 *   widget_color_index   Int    0=Forest 1=Midnight 2=Ocean 3=Purple
 *   habit_N_name         String name of habit at index N
 *   habit_N_streak       String streak label of habit at index N ("21 days")
 */
class AvoidWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val ACTION_CYCLE = "com.roymassaad.avoid_todo.ACTION_CYCLE_WIDGET"
        private const val PREFS_NAME = "HomeWidgetPreferences"
    }

    // ── Tap-to-cycle ──────────────────────────────────────────────────────────
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_CYCLE) {
            val prefs     = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val itemCount = prefs.getInt("widget_item_count", 1).coerceAtLeast(1)
            val next      = (prefs.getInt("widget_current_index", 0) + 1) % itemCount
            prefs.edit().putInt("widget_current_index", next).apply()

            val manager = AppWidgetManager.getInstance(context)
            val ids     = manager.getAppWidgetIds(ComponentName(context, AvoidWidgetProvider::class.java))
            onUpdate(context, manager, ids, prefs)
            return
        }
        super.onReceive(context, intent)
    }

    // ── Widget draw ───────────────────────────────────────────────────────────
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val habitCount   = widgetData.getInt("habit_count",          0)
        val itemCount    = widgetData.getInt("widget_item_count",    0)
        val colorIndex   = widgetData.getInt("widget_color_index",   0)
        val currentIndex = widgetData.getInt("widget_current_index", 0)
        val safeIndex    = if (itemCount > 0) currentIndex % itemCount else 0

        val habitName   = widgetData.getString("habit_${safeIndex}_name",   "") ?: ""
        val streakLabel = widgetData.getString("habit_${safeIndex}_streak", "") ?: ""

        val bgRes = when (colorIndex) {
            1    -> R.drawable.widget_background_midnight
            2    -> R.drawable.widget_background_ocean
            3    -> R.drawable.widget_background_purple
            else -> R.drawable.widget_background
        }

        // ── PendingIntents ────────────────────────────────────────────────────
        val cycleIntent = Intent(context, AvoidWidgetProvider::class.java).apply {
            action = ACTION_CYCLE
        }
        val cyclePi = PendingIntent.getBroadcast(
            context, 0, cycleIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val launchPi = context.packageManager
            .getLaunchIntentForPackage(context.packageName)
            ?.let { launchIntent ->
                PendingIntent.getActivity(
                    context, 1, launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
            }

        // ── Build views ───────────────────────────────────────────────────────
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.avoid_widget)

            views.setInt(R.id.widget_root, "setBackgroundResource", bgRes)

            // Main area → cycle
            views.setOnClickPendingIntent(R.id.widget_root, cyclePi)
            // ↗ icon → open app
            if (launchPi != null) {
                views.setOnClickPendingIntent(R.id.widget_open_app, launchPi)
            }

            if (itemCount == 0 || habitName.isEmpty()) {
                views.setTextViewText(R.id.widget_label,        "AVOID TODO")
                views.setTextViewText(R.id.widget_habit_name,   "No active habits")
                views.setTextViewText(R.id.widget_streak,        "\u2013")
                views.setTextViewText(R.id.widget_streak_label, "Open app to start")
            } else {
                val countLabel = if (habitCount == 1) "AVOIDING 1 HABIT"
                                 else                 "AVOIDING $habitCount HABITS"
                // Show which page we're on when there are multiple habits
                val pageHint   = if (itemCount > 1) "  ${safeIndex + 1}/$itemCount" else ""
                views.setTextViewText(R.id.widget_label,        countLabel + pageHint)
                views.setTextViewText(R.id.widget_habit_name,   habitName)
                views.setTextViewText(R.id.widget_streak,        streakLabel)
                views.setTextViewText(R.id.widget_streak_label, "\uD83D\uDD25 streak\u2011free")
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
