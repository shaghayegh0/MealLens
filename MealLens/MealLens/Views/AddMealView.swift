import SwiftUI
import UIKit

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: MealStore

    @State private var name = ""
    @State private var caloriesText = ""
    @State private var ingredients = ""
    @State private var mealType: MealEntry.MealType = .lunch
    @State private var date = Date()
    @State private var showDatePicker = false
    @State private var selectedImage: UIImage?
    @State private var showImageSource = false
    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var quickSearch = ""
    @State private var showQuickFoods = true

    private var calories: Int { Int(caloriesText) ?? 0 }
    private var canSave: Bool { !name.isEmpty && calories > 0 }

    var filteredFoods: [QuickFood] {
        QuickFoods.filtered(by: quickSearch)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        photoSection
                        formSection
                        quickFoodsSection
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppTheme.background, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .foregroundColor(canSave ? AppTheme.accent : AppTheme.textTertiary)
                        .disabled(!canSave)
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(capturedImage: $selectedImage)
        }
        .sheet(isPresented: $showLibrary) {
            PhotoLibraryView(capturedImage: $selectedImage)
        }
        .actionSheet(isPresented: $showImageSource) {
            ActionSheet(title: Text("Add Photo"), buttons: [
                .default(Text("Take Photo")) { showCamera = true },
                .default(Text("Choose from Library")) { showLibrary = true },
                .cancel()
            ])
        }
    }

    // MARK: - Photo Section
    private var photoSection: some View {
        Button { showImageSource = true } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.surface)
                    .frame(height: 160)

                if let img = selectedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 28))
                            .foregroundColor(AppTheme.textTertiary)
                        Text("Add Photo (optional)")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textTertiary)
                    }
                }
            }
        }
    }

    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Meal Name")
                TextField("e.g. Chicken & Rice", text: $name)
                    .textFieldStyle(AppTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Calories")
                HStack {
                    TextField("0", text: $caloriesText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(AppTextFieldStyle())
                    Text("kcal")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.leading, 4)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Type")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(MealEntry.MealType.allCases, id: \.self) { type in
                            Button {
                                mealType = type
                            } label: {
                                HStack(spacing: 6) {
                                    Text(type.emoji)
                                    Text(type.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(mealType == type ? .semibold : .regular)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(mealType == type ? AppTheme.accent : AppTheme.surfaceRaised)
                                .foregroundColor(mealType == type ? .white : AppTheme.textSecondary)
                                .clipShape(Capsule())
                                .animation(.easeInOut(duration: 0.2), value: mealType)
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Ingredients (optional)")
                TextField("e.g. chicken, rice, vegetables", text: $ingredients)
                    .textFieldStyle(AppTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Time (optional)")
                Button {
                    withAnimation { showDatePicker.toggle() }
                } label: {
                    HStack {
                        Text(date, style: .time)
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(14)
                    .background(AppTheme.surfaceRaised)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if showDatePicker {
                    DatePicker("", selection: $date, displayedComponents: [.hourAndMinute, .date])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                }
            }
        }
    }

    // MARK: - Quick Foods
    private var quickFoodsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation { showQuickFoods.toggle() }
            } label: {
                HStack {
                    Text("Quick Add")
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Image(systemName: showQuickFoods ? "chevron.up" : "chevron.down")
                        .foregroundColor(AppTheme.textSecondary)
                        .font(.caption)
                }
            }

            if showQuickFoods {
                TextField("Search foods...", text: $quickSearch)
                    .textFieldStyle(AppTextFieldStyle())

                LazyVStack(spacing: 8) {
                    ForEach(filteredFoods) { food in
                        Button {
                            name = food.name
                            caloriesText = "\(food.calories)"
                            ingredients = food.ingredients
                            mealType = food.type
                        } label: {
                            HStack {
                                Text(food.emoji)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(food.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppTheme.textPrimary)
                                    Text(food.ingredients)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.textSecondary)
                                        .lineLimit(1)
                                }
                                Spacer()
                                Text("\(food.calories) kcal")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.accent)
                            }
                            .padding(12)
                            .background(AppTheme.surfaceRaised)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(AppTheme.textSecondary)
            .textCase(.uppercase)
            .tracking(1)
    }

    private func save() {
        let entry = MealEntry(
            name: name,
            calories: calories,
            ingredients: ingredients,
            date: date,
            imageData: selectedImage?.jpegData(compressionQuality: 0.6),
            mealType: mealType
        )
        store.add(entry)
        dismiss()
    }
}

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(AppTheme.textPrimary)
            .padding(14)
            .background(AppTheme.surfaceRaised)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
