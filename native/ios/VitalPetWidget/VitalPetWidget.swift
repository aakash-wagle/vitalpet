import WidgetKit
import SwiftUI

// MARK: - Widget Bundle
@main
struct VitalPetWidgetBundle: WidgetBundle {
    var body: some Widget {
        VitalPetWidget()
    }
}

// MARK: - Widget Configuration
struct VitalPetWidget: Widget {
    let kind = "VitalPetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetDataProvider()) { entry in
            VitalPetEntryView(entry: entry)
        }
        .configurationDisplayName("VitalPet")
        .description("Check in on your pet companion.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
