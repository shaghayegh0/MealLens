# MealLens – Calorie Journal

A clean, offline iOS calorie tracking app. 

## Setup

1. Copy all Swift files 
5. Clean build: ⌘+Shift+K, then Run ▶

## File Structure

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


