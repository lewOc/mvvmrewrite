import Foundation

enum FashnAPIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(String)
}

actor FashnAPIService {
    private let baseURL = "https://api.fashn.ai/v1/"
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateTryOn(userImage: Data, garmentImage: Data) async throws -> URL {
        guard let url = URL(string: "\(baseURL)try-on/run") else {
            throw FashnAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // Add user image
        body.append(createFormData(boundary: boundary, name: "user_image", fileName: "user.jpg", data: userImage))
        // Add garment image
        body.append(createFormData(boundary: boundary, name: "garment_image", fileName: "garment.jpg", data: garmentImage))
        // Add final boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FashnAPIError.invalidResponse
        }
        
        let result = try JSONDecoder().decode(TryOnResponse.self, from: data)
        return result.resultURL
    }
    
    private func createFormData(boundary: String, name: String, fileName: String, data: Data) -> Data {
        var formData = Data()
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        formData.append(data)
        formData.append("\r\n".data(using: .utf8)!)
        return formData
    }
}

struct TryOnResponse: Codable {
    let resultURL: URL
    
    enum CodingKeys: String, CodingKey {
        case resultURL = "result_url"
    }
} 