import SwiftUI

struct HomeView: View {
    @ObservedObject var store: MealStore
    @State private var showAddMeal = false
    let goal = 1500

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    statsRow
                    todayMealsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }

            VStack {
                Spacer()
                Button { showAddMeal = true } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Log Meal")
                            .font(.system(.body, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 40)
                    .background(AppTheme.accentGradient)
                    .clipShape(Capsule())
                    .shadow(color: AppTheme.accent.opacity(0.5), radius: 20, y: 8)
                }
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showAddMeal) {
            AddMealView(store: store)
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greetingText())
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                    Text("Today")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                Spacer()
                Text(Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.surface)
                    .clipShape(Capsule())
            }

            HStack {
                Spacer()
                CalorieRing(consumed: store.todayCalories, goal: goal, size: 200)
                Spacer()
            }
        }
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(
                value: "\(max(0, goal - store.todayCalories))",
                label: "Remaining",
                icon: "flame",
                color: AppTheme.accentWarm
            )
            statCard(
                value: "\(store.todayEntries.count)",
                label: "Meals logged",
                icon: "fork.knife",
                color: AppTheme.accentGreen
            )
            statCard(
                value: "\(Int((Double(store.todayCalories) / Double(goal)) * 100))%",
                label: "Of daily goal",
                icon: "chart.bar",
                color: AppTheme.accent
            )
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(1)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Today's Meals
    private var todayMealsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Log")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                if !store.todayEntries.isEmpty {
                    Text("\(store.todayCalories) kcal total")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            if store.todayEntries.isEmpty {
                emptyState
            } else {
                ForEach(store.todayEntries) { entry in
                    MealCard(entry: entry) {
                        store.delete(entry)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("🍽️")
                .font(.system(size: 48))
            Text("Nothing logged yet")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
            Text("Tap Log Meal to get started")
                .font(.caption)
                .foregroundColor(AppTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning 🌅"
        case 12..<17: return "Good afternoon ☀️"
        default:      return "Good evening 🌙"
        }
    }
}
