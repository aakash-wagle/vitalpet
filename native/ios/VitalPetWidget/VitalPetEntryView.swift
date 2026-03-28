import SwiftUI
import WidgetKit

/// SwiftUI views for .systemSmall and .systemMedium widget families.
struct VitalPetEntryView: View {
    let entry: PetEntry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: PetEntry

    var body: some View {
        VStack {
            // TODO: load widget_sprites/<species>_<state>.png
            Text(entry.petName)
                .font(.headline)
            Text("\(entry.streak) day streak")
                .font(.caption)
        }
        .padding()
    }
}

struct MediumWidgetView: View {
    let entry: PetEntry

    var body: some View {
        HStack {
            SmallWidgetView(entry: entry)
            Spacer()
            WellnessSparkline(scores: [])
        }
        .padding()
    }
}
