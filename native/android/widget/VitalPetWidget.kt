// POST-HACKATHON — Android parity sprint A.1
// Kotlin Glance AppWidget

package com.vitalpet.widget

import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver

class VitalPetWidget : GlanceAppWidget() {
    // TODO: implement Glance widget composition
}

class VitalPetWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = VitalPetWidget()
}
