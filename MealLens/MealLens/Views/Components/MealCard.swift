import SwiftUI

struct MealCard: View {
    let entry: MealEntry
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.surfaceRaised)
                    .frame(width: 58, height: 58)

                if let data = entry.imageData, let img = UIImage(data: data) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 58, height: 58)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Text(entry.mealType.emoji)
                        .font(.system(size: 26))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.system(.body, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(entry.mealType.rawValue)
                        .font(.caption)
                        .foregroundColor(AppTheme.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(AppTheme.accent.opacity(0.15))
                        .clipShape(Capsule())

                    if !entry.ingredients.isEmpty {
                        Text(entry.ingredients)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineLimit(1)
                    }
                }

                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(AppTheme.textTertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.calories)")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(AppTheme.accent)
                Text("kcal")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppTheme.textTertiary)
                    .textCase(.uppercase)
                    .tracking(1)
            }
        }
        .padding(14)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
