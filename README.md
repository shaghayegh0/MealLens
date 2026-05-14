# MealLens 🍽️
**An iOS calorie journal.**

![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/iOS-18%2B-blue?style=flat-square&logo=apple)

---

## Features

### 🏠 Home
- Animated calorie ring showing daily progress toward your goal
- Turns warm orange when you exceed your target
- Three stat cards: calories remaining, meals logged, % of daily goal
- Time-aware greeting (morning / afternoon / evening)
- Swipe-to-delete meal entries

### ➕ Add Meal
- Log name, calories, meal type, ingredients, time, and an optional photo
- Take a photo or pick from your library
- Quick-add panel with 30+ common foods, searchable by name
- Tap any quick-add item to auto-fill the form

### 📔 Journal
- Full history of every logged day
- Sticky date headers with per-day calorie totals and a mini progress bar
- Highlights over-goal days in warm orange

### 📈 Trends
- Bar chart with time range selector: 7D / 30D / 90D / 1Y
- Summary cards: average kcal/day, days tracked, best day
- Meal type breakdown (Breakfast, Lunch, Dinner, Snack, Drink) with proportional bars
- Goal line overlay on chart

---

## Tech Stack

| Area | Details |
|---|---|
| Language | Swift 5.9 |
| UI Framework | SwiftUI |
| Charts | Swift Charts (iOS 16+) |
| Storage | Local persistent store via `MealStore` |
| Camera | `UIImagePickerController` wrapped in SwiftUI |
| Architecture | MVVM — `MealStore` as `@ObservableObject` |
| Design | Dark mode only, warm terracotta accent (`AppTheme`) |

---

## Project Structure

```
MealLens/
├── MealLensApp.swift
├── CameraView.swift
├── Theme/
│   └── AppTheme.swift
├── Models/
│   ├── MealEntry.swift
│   └── MealStore.swift
├── Data/
│   └── QuickFoods.swift
└── Views/
    ├── HomeView.swift
    ├── AddMealView.swift
    ├── JournalView.swift
    ├── TrendsView.swift
    └── Components/
        ├── CalorieRing.swift
        └── MealCard.swift
```

---

## Setup

1. Clone the repo and open in Xcode
2. Delete: `ContentView.swift`, `APIService.swift`, `ClaudeVisionService.swift`
3. Keep the updated `CameraView.swift`
4. Replace `MealLensApp.swift` with the version included
5. Clean build: `⌘ + Shift + K`, then Run ▶

> **Note:** Daily goal defaults to 2000 kcal. Search for `let goal = 2000` to change it.

---

## Requirements

- iOS 18+
- Xcode 15+
- No external packages or dependencies
