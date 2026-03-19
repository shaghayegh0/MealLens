import SwiftUI
import Charts

struct TrendsView: View {
    @ObservedObject var store: MealStore
    @State private var selectedRange: TimeRange = .week
    let goal = 2000

    enum TimeRange: String, CaseIterable {
        case week        = "7D"
        case month       = "30D"
        case threeMonths = "90D"
        case year        = "1Y"

        var days: Int {
            switch self {
            case .week:        return 7
            case .month:       return 30
            case .threeMonths: return 90
            case .year:        return 365
            }
        }
    }

    var chartData: [(date: Date, calories: Int, label: String)] {
        store.dailyCalories(for: selectedRange.days)
    }

    var average: Int {
        let nonZero = chartData.filter { $0.calories > 0 }
        guard !nonZero.isEmpty else { return 0 }
        return nonZero.reduce(0) { $0 + $1.calories } / nonZero.count
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    summaryCards
                    rangeSelector
                    chartSection
                    mealTypeBreakdown
                }
                .padding(20)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Summary Cards
    private var summaryCards: some View {
        HStack(spacing: 12) {
            trendCard(title: "Avg / day",     value: "\(average)",                                       unit: "kcal",  color: AppTheme.accent)
            trendCard(title: "Days tracked",  value: "\(chartData.filter { $0.calories > 0 }.count)",    unit: "days",  color: AppTheme.accentGreen)
            trendCard(title: "Best day",      value: "\(chartData.map { $0.calories }.max() ?? 0)",      unit: "kcal",  color: AppTheme.accentWarm)
        }
    }

    private func trendCard(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(AppTheme.textSecondary)
                .textCase(.uppercase)
                .tracking(0.8)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(color)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Range Selector
    private var rangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button {
                    withAnimation { selectedRange = range }
                } label: {
                    Text(range.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedRange == range ? .semibold : .regular)
                        .foregroundColor(selectedRange == range ? .white : AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedRange == range ?
                            AnyView(AppTheme.accentGradient.clipShape(RoundedRectangle(cornerRadius: 10))) :
                            AnyView(Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Chart
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Daily Calories")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                HStack(spacing: 4) {
                    Circle()
                        .fill(AppTheme.textTertiary)
                        .frame(width: 6, height: 6)
                    Text("Goal: \(goal) kcal")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            Chart {
                ForEach(chartData, id: \.date) { item in
                    BarMark(
                        x: .value("Date", item.label),
                        y: .value("Calories", item.calories)
                    )
                    .foregroundStyle(
                        item.calories > goal ?
                        AnyShapeStyle(AppTheme.accentWarm) :
                        AnyShapeStyle(AppTheme.accentGradient)
                    )
                    .cornerRadius(6)
                }

                RuleMark(y: .value("Goal", goal))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(AppTheme.textTertiary)
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let str = value.as(String.self) {
                            Text(str)
                                .font(.system(size: 9))
                                .foregroundColor(AppTheme.textTertiary)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let int = value.as(Int.self) {
                            Text("\(int)")
                                .font(.system(size: 9))
                                .foregroundColor(AppTheme.textTertiary)
                        }
                    }
                    AxisGridLine()
                        .foregroundStyle(AppTheme.surfaceRaised)
                }
            }
            .frame(height: 220)
            .padding(16)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Meal Type Breakdown
    private var mealTypeBreakdown: some View {
        let data = mealTypeData()

        return VStack(alignment: .leading, spacing: 12) {
            Text("By Meal Type")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)

            if data.isEmpty {
                Text("No data for this period")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack(spacing: 10) {
                    ForEach(data, id: \.type) { item in
                        HStack(spacing: 12) {
                            Text(item.type.emoji)
                                .font(.title3)
                                .frame(width: 32)
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.type.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.textPrimary)
                                    Spacer()
                                    Text("\(item.calories) kcal")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppTheme.accent)
                                }
                                GeometryReader { geo in
                                    let maxCal = data.first?.calories ?? 1
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(AppTheme.ringTrack)
                                            .frame(height: 6)
                                        Capsule()
                                            .fill(AppTheme.accentGradient)
                                            .frame(
                                                width: maxCal > 0 ?
                                                    geo.size.width * CGFloat(item.calories) / CGFloat(maxCal) : 0,
                                                height: 6
                                            )
                                    }
                                }
                                .frame(height: 6)
                            }
                        }
                        .padding(12)
                        .background(AppTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    private func mealTypeData() -> [(type: MealEntry.MealType, calories: Int)] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -selectedRange.days, to: Date())!
        let recent = store.entries.filter { $0.date >= cutoff }

        return MealEntry.MealType.allCases.compactMap { type in
            let cal = recent.filter { $0.mealType == type }.reduce(0) { $0 + $1.calories }
            return cal > 0 ? (type: type, calories: cal) : nil
        }
        .sorted { $0.calories > $1.calories }
    }
}
