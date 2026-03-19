import Foundation

struct MealEntry: Codable, Identifiable {
    var id = UUID()
    var name: String
    var calories: Int
    var ingredients: String
    var date: Date
    var imageData: Data?
    var mealType: MealType

    enum MealType: String, Codable, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        case drink = "Drink"

        var emoji: String {
            switch self {
            case .breakfast: return "🥪"
            case .lunch:     return "🥘"
            case .dinner:    return "🍜"
            case .snack:     return "🍫"
            case .drink:     return "🥤"
            }
        }
    }

    var dayKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    var weekKey: String {
        let cal = Calendar.current
        let week = cal.component(.weekOfYear, from: date)
        let year = cal.component(.year, from: date)
        return "\(year)-W\(week)"
    }

    var monthKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM"
        return f.string(from: date)
    }
}
