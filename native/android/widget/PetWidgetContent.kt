// POST-HACKATHON — Android parity sprint A.1
package com.vitalpet.widget

import androidx.compose.runtime.Composable
import androidx.glance.layout.Column
import androidx.glance.text.Text

@Composable
fun PetWidgetContent(petName: String, streak: Int) {
    // TODO: implement small + medium Glance composable
    Column {
        Text(petName)
        Text("$streak day streak")
    }
}
