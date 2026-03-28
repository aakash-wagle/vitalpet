// POST-HACKATHON — Android parity sprint A.1
package com.vitalpet.widget

import android.content.Context

object WidgetDataProvider {
    // home_widget stores data with the prefix flutter.<key>
    private const val PREFS_SUFFIX = "FlutterSharedPreferences"

    fun getPetName(context: Context): String {
        val prefs = context.getSharedPreferences(PREFS_SUFFIX, Context.MODE_PRIVATE)
        return prefs.getString("flutter.pet_name", "Pet") ?: "Pet"
    }

    fun getPetState(context: Context): Int {
        val prefs = context.getSharedPreferences(PREFS_SUFFIX, Context.MODE_PRIVATE)
        return prefs.getInt("flutter.pet_state", 3)
    }

    fun getStreak(context: Context): Int {
        val prefs = context.getSharedPreferences(PREFS_SUFFIX, Context.MODE_PRIVATE)
        return prefs.getInt("flutter.streak", 0)
    }
}
