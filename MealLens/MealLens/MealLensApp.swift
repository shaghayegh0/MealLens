import SwiftUI

@main
struct MealLensApp: App {
    @StateObject private var store = MealStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var store: MealStore

    var body: some View {
        TabView {
            HomeView(store: store)
                .tabItem {
                    Label("Today", systemImage: "flame.fill")
                }

            JournalView(store: store)
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }

            TrendsView(store: store)
                .tabItem {
                    Label("Trends", systemImage: "chart.bar.fill")
                }
        }
        .tint(AppTheme.accent)
        .toolbarBackground(AppTheme.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
