import UIKit

struct APIService {
    static let apiKey = "99bb50579200b84bc93806308f63801f"
    static let appId = "58192088"
    
    static func uploadImage(_ image: UIImage, completion: @escaping (Int?) -> Void) {
        // Nutritionix v2 endpoint for natural language nutrients
        guard let url = URL(string: "https://trackapi.nutritionix.com/v2/natural/nutrients") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers for v2 API
        request.setValue(appId, forHTTPHeaderField: "x-app-id")
        request.setValue(apiKey, forHTTPHeaderField: "x-app-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // For demo purposes, using a generic query
        // In production, you'd want to use image recognition first
        let body: [String: Any] = [
            "query": "1 meal"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(nil)
            return
        }
        
        request.httpBody = jsonData
        
        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            // Parse response data
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Print raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
            }
            
            // Parse JSON
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let foods = json["foods"] as? [[String: Any]],
                   let firstFood = foods.first,
                   let calories = firstFood["nf_calories"] as? Double {
                    completion(Int(calories))
                } else {
                    print("Could not parse calories from response")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}