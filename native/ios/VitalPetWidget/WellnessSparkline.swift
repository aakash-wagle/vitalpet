import SwiftUI

/// 7-bar horizontal mini chart rendered with SwiftUI shapes.
///
/// Each bar's height is proportional to its wellness score (1–10).
/// A score of 0 means the day was missed and renders as a short grey stub.
struct WellnessSparkline: View {
    /// Exactly 7 values expected, oldest first. 0 = day was missed.
    let scores: [Int]

    private let maxBarHeight: CGFloat = 44
    private let barWidth: CGFloat = 8
    private let barSpacing: CGFloat = 3

    var body: some View {
        HStack(alignment: .bottom, spacing: barSpacing) {
            ForEach(paddedScores.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color(for: paddedScores[i]))
                    .frame(width: barWidth, height: height(for: paddedScores[i]))
            }
        }
        .frame(height: maxBarHeight, alignment: .bottom)
    }

    // MARK: Private

    /// Ensure we always render exactly 7 bars, padding with 0 if needed.
    private var paddedScores: [Int] {
        Array((scores + Array(repeating: 0, count: 7)).prefix(7))
    }

    /// Minimum stub height so missed days are still visible as a floor line.
    private func height(for score: Int) -> CGFloat {
        guard score > 0 else { return 4 }
        return max(6, CGFloat(score) / 10.0 * maxBarHeight)
    }

    private func color(for score: Int) -> Color {
        switch score {
        case 0:
            // Missed day — grey stub
            return Color.white.opacity(0.18)
        case 1...4:
            // Low wellness — warm red
            return Color(red: 1.00, green: 0.40, blue: 0.38)
        case 5...7:
            // Mid wellness — amber
            return Color(red: 1.00, green: 0.78, blue: 0.20)
        default:
            // High wellness (8–10) — teal green
            return Color(red: 0.28, green: 0.85, blue: 0.58)
        }
    }
}
