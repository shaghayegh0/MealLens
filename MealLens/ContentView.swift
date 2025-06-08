import SwiftUI
import UIKit

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var showImageSourcePicker = false
    @State private var capturedImage: UIImage?
    @State private var estimatedCalories: Int?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("MealLens")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Eat smart, stay healthy")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 100)
                
                // Image Preview
                ZStack {
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 240)
                            .cornerRadius(16)
                            .shadow(radius: 8)
                    } else {
                        Image("main")
                            .frame(height: 500)
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .foregroundColor(Color(.systemGray4))
                            .padding(40)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .padding(.horizontal, 24)
                
                // Results Section
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else if let calories = estimatedCalories {
                        VStack(spacing: 8) {
                            Text("Estimated Calories")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("\(calories) kcal")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    } else if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                // Scan Button
                Button(action: { showImageSourcePicker.toggle() }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Scan Meal")
                    }
                    .font(.title3)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.mint, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
                .shadow(color: Color.blue.opacity(0.3), radius: 10, y: 5)
                .actionSheet(isPresented: $showImageSourcePicker) {
                    ActionSheet(
                        title: Text("Select Image Source"),
                        buttons: [
                            .default(Text("Take Photo")) { isShowingCamera = true },
                            .default(Text("Choose from Library")) { isShowingPhotoLibrary = true },
                            .cancel()
                        ]
                    )
                }
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraView(capturedImage: $capturedImage)
        }
        .sheet(isPresented: $isShowingPhotoLibrary) {
            PhotoLibraryView(capturedImage: $capturedImage)
        }
        .onChange(of: capturedImage) { newImage in
            if let image = newImage {
                analyzeImage(image)
            }
        }
    }
    
    private func analyzeImage(_ image: UIImage) {
        isLoading = true
        errorMessage = nil
        
        APIService.uploadImage(image) { calories in
            DispatchQueue.main.async {
                isLoading = false
                if let calories = calories {
                    estimatedCalories = calories
                } else {
                    errorMessage = "Couldn't estimate calories. Please try again."
                }
            }
        }
    }
}

struct PhotoLibraryView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoLibraryView
        
        init(parent: PhotoLibraryView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
