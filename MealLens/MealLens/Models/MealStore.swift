import Foundation
import Combine

class MealStore: ObservableObject {
    @Published var entries: [MealEntry] = []

    private let key = "meal_entries_v2"

    init() { load() }

    // MARK: - Today
    var todayKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    var todayEntries: [MealEntry] {
        entries.filter { $0.dayKey == todayKey }
               .sorted { $0.date > $1.date }
    }

    var todayCalories: Int {
        todayEntries.reduce(0) { $0 + $1.calories }
    }

    // MARK: - Grouped by day for journal
    var entriesByDay: [(key: String, date: Date, entries: [MealEntry], total: Int)] {
        let grouped = Dictionary(grouping: entries) { $0.dayKey }
        return grouped.compactMap { key, items in
            guard let first = items.first else { return nil }
            let sorted = items.sorted { $0.date > $1.date }
            let total = items.reduce(0) { $0 + $1.calories }
            return (key: key, date: first.date, entries: sorted, total: total)
        }
        .sorted { $0.key > $1.key }
    }

    // MARK: - Trends data
    func dailyCalories(for days: Int) -> [(date: Date, calories: Int, label: String)] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let formatter = DateFormatter()

        return (0..<days).reversed().map { offset in
            let date = cal.date(byAdding: .day, value: -offset, to: today)!
            let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
            let key = f.string(from: date)
            let total = entries.filter { $0.dayKey == key }.reduce(0) { $0 + $1.calories }
            formatter.dateFormat = days <= 7 ? "EEE" : (days <= 31 ? "d" : "MMM")
            return (date: date, calories: total, label: formatter.string(from: date))
        }
    }

    // MARK: - CRUD
    func add(_ entry: MealEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func delete(_ entry: MealEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([MealEntry].self, from: data)
        else { return }
        entries = decoded
    }
}
