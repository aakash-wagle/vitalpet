// POST-HACKATHON — Android parity sprint A.1
package com.vitalpet.widget

import androidx.compose.runtime.Composable
import androidx.glance.layout.Row
import androidx.glance.layout.Box
import androidx.glance.unit.ColorProvider
import androidx.glance.background

@Composable
fun WellnessSparkline(scores: List<Int>) {
    // TODO: implement 7 colored Box composables as mini bar chart
    Row {
        scores.forEach { _ ->
            Box(modifier = androidx.glance.GlanceModifier) {}
        }
    }
}
