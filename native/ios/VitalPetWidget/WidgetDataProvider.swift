import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct PetEntry: TimelineEntry {
    let date: Date
    let petName: String
    /// 1=thriving, 2=happy, 3=neutral, 4=unwell, 5=critical. Matches PetStateEnum index+1 in Dart.
    let petStateIndex: Int
    let streak: Int
    /// Last 7 daily wellness scores, oldest first. 0 = day missed (shown as grey bar).
    let wellnessSparkline: [Int]
}

// MARK: - Timeline Provider

/// Reads all widget display data from the App Group UserDefaults shared container.
/// Keys must exactly match what `widget_data_writer.dart` writes via `home_widget`.
struct WidgetDataProvider: TimelineProvider {
    private let appGroupID = "group.com.vitalpet.shared"

    // Placeholder shown while the widget is loading for the first time.
    func placeholder(in context: Context) -> PetEntry {
        PetEntry(
            date: .now,
            petName: "Mochi",
            petStateIndex: 1,
            streak: 7,
            wellnessSparkline: [6, 7, 8, 5, 9, 7, 8]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PetEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PetEntry>) -> Void) {
        // Refresh once at the start of tomorrow — pet state changes at midnight.
        let midnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86_400))
        completion(Timeline(entries: [makeEntry()], policy: .after(midnight)))
    }

    // MARK: Private

    private func makeEntry() -> PetEntry {
        let defaults = UserDefaults(suiteName: appGroupID)

        // Dart writer: HomeWidget.saveWidgetData<String>('sparkline', sparkline.take(7).join(','))
        let sparklineStr = defaults?.string(forKey: "sparkline") ?? ""
        let parsed = sparklineStr
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        // Ensure exactly 7 entries; pad with 0 (= missed) if fewer scores exist.
        let padded = Array((parsed + Array(repeating: 0, count: 7)).prefix(7))

        return PetEntry(
            date: .now,
            petName: defaults?.string(forKey: "pet_name") ?? "Pet",
            petStateIndex: max(1, defaults?.integer(forKey: "pet_state") ?? 1),
            streak: defaults?.integer(forKey: "streak") ?? 0,
            wellnessSparkline: padded
        )
    }
}
