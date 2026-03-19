import SwiftUI

struct JournalView: View {
    @ObservedObject var store: MealStore
    let goal = 2000

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if store.entriesByDay.isEmpty {
                VStack(spacing: 12) {
                    Text("📔")
                        .font(.system(size: 48))
                    Text("No entries yet")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)
                    Text("Your meal history will appear here")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textTertiary)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16, pinnedViews: .sectionHeaders) {
                        ForEach(store.entriesByDay, id: \.key) { day in
                            Section {
                                VStack(spacing: 8) {
                                    ForEach(day.entries) { entry in
                                        MealCard(entry: entry) {
                                            store.delete(entry)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)
                            } header: {
                                dayHeader(date: day.date, total: day.total)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private func dayHeader(date: Date, total: Int) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(dayLabel(date))
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
            HStack(spacing: 8) {
                Text("\(total)")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundColor(total > goal ? AppTheme.accentWarm : AppTheme.accent)
                Text("kcal")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.ringTrack)
                        .frame(width: 48, height: 4)
                    Capsule()
                        .fill(total > goal ? AppTheme.accentWarm : AppTheme.accent)
                        .frame(width: min(48 * CGFloat(total) / CGFloat(goal), 48), height: 4)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(AppTheme.background.opacity(0.95))
    }

    private func dayLabel(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date)     { return "Today" }
        if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
        let f = DateFormatter(); f.dateFormat = "EEEE"
        return f.string(from: date)
    }
}
