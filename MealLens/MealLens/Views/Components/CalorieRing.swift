import SwiftUI

struct CalorieRing: View {
    let consumed: Int
    let goal: Int
    var size: CGFloat = 200

    private var progress: Double {
        min(Double(consumed) / Double(goal), 1.0)
    }

    private var overGoal: Bool { consumed > goal }

    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.accent.opacity(0.08))
                .frame(width: size * 0.85, height: size * 0.85)
                .blur(radius: 20)

            Circle()
                .stroke(AppTheme.ringTrack, lineWidth: size * 0.07)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    overGoal ? AppTheme.accentWarm : AppTheme.accent,
                    style: StrokeStyle(lineWidth: size * 0.07, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: consumed)

            VStack(spacing: 2) {
                Text("\(consumed)")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Text("kcal")
                    .font(.system(size: size * 0.08, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .textCase(.uppercase)
                    .tracking(2)
            }
        }
        .frame(width: size, height: size)
    }
}
