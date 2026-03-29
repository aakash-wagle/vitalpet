import SwiftUI
import WidgetKit

// MARK: - Root Entry View

/// Dispatches to the correct layout based on widget family.
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

// MARK: - Small (2×2)

/// Dog image · streak count · "Check in" deep-link.
/// Background is black so the dog PNG blends correctly.
struct SmallWidgetView: View {
    let entry: PetEntry

    var body: some View {
        ZStack {
            Color.black

            VStack(spacing: 6) {
                Image("greeting")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 72)

                Text("\(entry.streak) day streak")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Text("Check in →")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.40, green: 0.80, blue: 1.00))
            }
            .padding(12)
        }
        .widgetURL(URL(string: "vitalpet://checkin")!)
    }
}

// MARK: - Medium (4×2)

/// Left column: dog image + name + streak + "Check in" link.
/// Right column: 7-day WellnessSparkline.
struct MediumWidgetView: View {
    let entry: PetEntry

    var body: some View {
        ZStack {
            Color.black

            HStack(alignment: .center, spacing: 0) {
                // Left: pet info
                VStack(alignment: .leading, spacing: 5) {
                    Image("greeting")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 80)

                    Text(entry.petName)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text("\(entry.streak) day streak")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.65))

                    Text("Check in →")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.40, green: 0.80, blue: 1.00))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 1, height: 80)
                    .padding(.horizontal, 12)

                // Right: sparkline
                VStack(alignment: .center, spacing: 4) {
                    Text("7 days")
                        .font(.system(size: 9, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.45))

                    WellnessSparkline(scores: entry.wellnessSparkline)
                }
                .frame(width: 86)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .widgetURL(URL(string: "vitalpet://checkin")!)
    }
}
