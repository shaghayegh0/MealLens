import UIKit // THIS LINE MUST BE PRESENT

struct APIService {
    static let apiKey = "99bb50579200b84bc93806308f63801f"
    static let appId = "58192088"
    
    static func uploadImage(_ image: UIImage, completion: @escaping (Int?) -> Void) {
        guard let url = URL(string: "https://api.nutritionix.com/v1/analyze") else {
            completion(nil)
            return
        }
        
        // Convert image to Data (JPEG format)
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(nil)
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers
        request.setValue(appId, forHTTPHeaderField: "x-app-id")
        request.setValue(apiKey, forHTTPHeaderField: "x-app-key")
        
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"meal.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response here (same as before)
            // ... [rest of your existing code]
        }.resume()
    }
}
