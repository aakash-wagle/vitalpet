import SwiftUI

/// 7-bar mini sparkline rendered via SwiftUI Path.
struct WellnessSparkline: View {
    let scores: [Double]   // expected count: 7, each in 0–10

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(Array(scores.enumerated()), id: \.offset) { _, score in
                RoundedRectangle(cornerRadius: 2)
                    .fill(barColor(for: score))
                    .frame(width: 6, height: CGFloat(score / 10.0) * 40)
            }
        }
    }

    private func barColor(for score: Double) -> Color {
        switch score {
        case 8...: return .green
        case 5...: return .yellow
        default: return .red
        }
    }
}
