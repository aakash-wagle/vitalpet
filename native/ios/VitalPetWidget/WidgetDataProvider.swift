import WidgetKit
import SwiftUI

struct PetEntry: TimelineEntry {
    let date: Date
    let petName: String
    let petStateIndex: Int   // 1–5 maps to PetStateEnum
    let streak: Int
}

/// Reads pet state from the App Group UserDefaults shared container.
struct WidgetDataProvider: TimelineProvider {
    private let appGroupID = "group.com.vitalpet.shared"

    func placeholder(in context: Context) -> PetEntry {
        PetEntry(date: .now, petName: "Mochi", petStateIndex: 2, streak: 7)
    }

    func getSnapshot(in context: Context, completion: @escaping (PetEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PetEntry>) -> Void) {
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
        completion(Timeline(entries: [entry()], policy: .after(refreshDate)))
    }

    private func entry() -> PetEntry {
        let defaults = UserDefaults(suiteName: appGroupID)
        return PetEntry(
            date: .now,
            petName: defaults?.string(forKey: "pet_name") ?? "Pet",
            petStateIndex: defaults?.integer(forKey: "pet_state") ?? 3,
            streak: defaults?.integer(forKey: "streak") ?? 0
        )
    }
}
