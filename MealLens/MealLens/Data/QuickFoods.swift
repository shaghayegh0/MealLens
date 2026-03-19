import Foundation

struct QuickFood: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let ingredients: String
    let type: MealEntry.MealType
    let emoji: String
}

struct QuickFoods {
    static let all: [QuickFood] = [
        // Breakfast
        QuickFood(name: "Oatmeal",          calories: 150, ingredients: "Oats, water, milk",                            type: .breakfast, emoji: "🥣"),
        QuickFood(name: "Scrambled Eggs",   calories: 200, ingredients: "Eggs, butter, salt",                           type: .breakfast, emoji: "🍳"),
        QuickFood(name: "Avocado Toast",    calories: 280, ingredients: "Bread, avocado, salt, lemon",                  type: .breakfast, emoji: "🥑"),
        QuickFood(name: "Greek Yogurt",     calories: 130, ingredients: "Greek yogurt, honey",                          type: .breakfast, emoji: "🍶"),
        QuickFood(name: "Pancakes",         calories: 350, ingredients: "Flour, eggs, milk, butter, maple syrup",       type: .breakfast, emoji: "🥞"),
        QuickFood(name: "Granola Bowl",     calories: 320, ingredients: "Granola, milk, berries, honey",                type: .breakfast, emoji: "🫐"),

        // Lunch
        QuickFood(name: "Caesar Salad",     calories: 300, ingredients: "Romaine, croutons, parmesan, dressing",        type: .lunch, emoji: "🥗"),
        QuickFood(name: "Chicken Sandwich", calories: 480, ingredients: "Chicken, bread, lettuce, tomato, mayo",        type: .lunch, emoji: "🥪"),
        QuickFood(name: "Lentil Soup",      calories: 230, ingredients: "Lentils, onion, carrot, cumin, tomato",        type: .lunch, emoji: "🍲"),
        QuickFood(name: "Tuna Wrap",        calories: 370, ingredients: "Tuna, tortilla, lettuce, cucumber, mayo",      type: .lunch, emoji: "🌯"),
        QuickFood(name: "Rice Bowl",        calories: 420, ingredients: "Rice, vegetables, soy sauce",                  type: .lunch, emoji: "🍚"),
        QuickFood(name: "Grilled Cheese",   calories: 400, ingredients: "Bread, cheddar, butter",                       type: .lunch, emoji: "🧀"),

        // Dinner
        QuickFood(name: "Grilled Salmon",   calories: 370, ingredients: "Salmon, olive oil, lemon, herbs",              type: .dinner, emoji: "🐟"),
        QuickFood(name: "Pasta Bolognese",  calories: 580, ingredients: "Pasta, ground beef, tomato sauce, parmesan",   type: .dinner, emoji: "🍝"),
        QuickFood(name: "Chicken & Rice",   calories: 450, ingredients: "Chicken breast, rice, vegetables",             type: .dinner, emoji: "🍗"),
        QuickFood(name: "Steak",            calories: 650, ingredients: "Beef steak, butter, garlic, rosemary",         type: .dinner, emoji: "🥩"),
        QuickFood(name: "Veggie Stir Fry",  calories: 280, ingredients: "Mixed vegetables, tofu, soy sauce",            type: .dinner, emoji: "🥦"),
        QuickFood(name: "Pizza (2 slices)", calories: 560, ingredients: "Dough, tomato sauce, cheese, toppings",        type: .dinner, emoji: "🍕"),
        QuickFood(name: "Ghormeh Sabzi",    calories: 480, ingredients: "Herbs, kidney beans, lamb, dried limes",       type: .dinner, emoji: "🫕"),
        QuickFood(name: "Chelow Kebab",     calories: 620, ingredients: "Rice, minced beef, onion, saffron, butter",    type: .dinner, emoji: "🍢"),
        QuickFood(name: "Fesenjan",         calories: 520, ingredients: "Walnut, pomegranate, chicken",                 type: .dinner, emoji: "🍛"),

        // Snacks
        QuickFood(name: "Apple",            calories: 95,  ingredients: "Apple",                                        type: .snack, emoji: "🍎"),
        QuickFood(name: "Banana",           calories: 105, ingredients: "Banana",                                       type: .snack, emoji: "🍌"),
        QuickFood(name: "Almonds",          calories: 160, ingredients: "Almonds",                                      type: .snack, emoji: "🌰"),
        QuickFood(name: "Dark Chocolate",   calories: 170, ingredients: "Dark chocolate 70%",                           type: .snack, emoji: "🍫"),
        QuickFood(name: "Hummus & Veggies", calories: 150, ingredients: "Hummus, carrot, cucumber, celery",             type: .snack, emoji: "🫛"),
        QuickFood(name: "Protein Bar",      calories: 220, ingredients: "Oats, protein, nuts, honey",                   type: .snack, emoji: "🍫"),

        // Drinks
        QuickFood(name: "Black Coffee",     calories: 5,   ingredients: "Coffee",                                       type: .drink, emoji: "☕️"),
        QuickFood(name: "Latte",            calories: 120, ingredients: "Espresso, steamed milk",                       type: .drink, emoji: "☕️"),
        QuickFood(name: "Orange Juice",     calories: 110, ingredients: "Orange juice",                                 type: .drink, emoji: "🍊"),
        QuickFood(name: "Smoothie",         calories: 250, ingredients: "Banana, berries, milk, honey",                 type: .drink, emoji: "🥤"),
        QuickFood(name: "Green Tea",        calories: 2,   ingredients: "Green tea",                                    type: .drink, emoji: "🍵"),
    ]

    static func filtered(by query: String) -> [QuickFood] {
        guard !query.isEmpty else { return all }
        return all.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.ingredients.localizedCaseInsensitiveContains(query)
        }
    }
}
