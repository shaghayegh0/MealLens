# MealLens – Calorie Journal

A clean, offline iOS calorie tracking app. No API needed — fully manual, fully private.

## Setup

1. Copy all Swift files from this zip into your Xcode project's MealLens source folder
2. In Xcode, delete: `ContentView.swift`, `APIService.swift`, `ClaudeVisionService.swift`
3. Keep: `CameraView.swift` (updated version included)
4. Replace: `MealLensApp.swift` with the new version
5. Clean build: ⌘+Shift+K, then Run ▶

## File Structure

Place files into Xcode groups exactly matching this layout:

```
MealLens/ (source group)
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

## Features

- Log meals with name, calories, type, ingredients, photo, time
- Quick-add from 30+ common foods
- Daily calorie ring with goal tracking
- Swipe to delete entries
- Journal view — all past days with totals
- Trends — bar charts for 7D / 30D / 90D / 1Y
- Meal type breakdown (breakfast, lunch, dinner, snack, drink)
- 100% offline — no API, no account needed
- Dark mode only, warm terracotta design

## Notes

- Daily goal is hardcoded to 2000 kcal — search for `let goal = 2000` to change it
- Charts require iOS 16+ (your project targets iOS 18, so you're fine)
- No external packages needed
