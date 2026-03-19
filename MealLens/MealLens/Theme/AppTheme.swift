import SwiftUI

struct AppTheme {
    static let background = Color(hex: "1C1A17")
    static let surface = Color(hex: "252320")
    static let surfaceRaised = Color(hex: "2E2B27")
    static let accent = Color(hex: "E8724A")
    static let accentWarm = Color(hex: "F0A050")
    static let accentGreen = Color(hex: "7FAF7B")
    static let textPrimary = Color(hex: "F2EDE4")
    static let textSecondary = Color(hex: "9C9488")
    static let textTertiary = Color(hex: "5C574F")
    static let calorieColor = Color(hex: "E8724A")
    static let ringTrack = Color(hex: "2E2B27")

    static let accentGradient = LinearGradient(
        colors: [Color(hex: "E8724A"), Color(hex: "F0A050")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let greenGradient = LinearGradient(
        colors: [Color(hex: "7FAF7B"), Color(hex: "A8D4A4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
