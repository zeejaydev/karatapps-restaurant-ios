//
//  ApiManager.swift
//  Restaurant
//
//  Created by Zaid Jamil on 8/9/26.
//

import Foundation

final class NetworkService {
    static let shared: NetworkService = NetworkService()
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    private let baseUrl = Configuration.apiBaseURL.absoluteString
    private let brandIdentifier = Configuration.brandId.absoluteString
    var token: String?
   
    init(token: String? = nil) {
       guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else {
           fatalError("Info.plist not found")
       }
       if let auth: String = infoDictionary["AuthToken"] as? String {
           print("AUTH_TOKEN")
           self.token = auth
       }
    }
    
    func apiCall<T: Decodable>(
        method: HttpMethod = .get,
        route: String,
        data: Data? = nil,
        responseType: T.Type,
        customDecoder: JSONDecoder? = nil,
        contentType: String = "application/json"
    ) async throws -> T {
        guard let url = URL(string: baseUrl + route) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(brandIdentifier, forHTTPHeaderField: "X-Brand")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if let requestData = data {
            request.httpBody = requestData
        }
        
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
               throw URLError(.unknown)
            }
            if 200..<300 ~= httpResponse.statusCode {
//                print("responseData: \(String(data: responseData, encoding: .utf8) ?? "")")
                guard let customDecoder else {
                    return try JSONDecoder().decode(T.self, from: responseData)
                }
                return try customDecoder.decode(T.self, from: responseData)
            } else {
//                print("responseData: \(String(data: responseData, encoding: .utf8) ?? "")")
                if let apiError = try? JSONDecoder().decode(APIError.self, from: responseData) {
                    throw apiError
                }
                throw URLError(.badServerResponse)
            }
        } catch {
            print("url: \(route)")
            print(error)
            throw error
        }
    }
    
    func apiCall(
        method: HttpMethod = .get,
        route: String,
        data: Data? = nil,
        contentType: String = "application/json"
    ) async throws {
        guard let url = URL(string: baseUrl + route) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(brandIdentifier, forHTTPHeaderField: "X-Brand")
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if let requestData = data {
            request.httpBody = requestData
        }
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.unknown)
        }
        if 200..<300 ~= httpResponse.statusCode {
            return  // Success, no body to decode
        } else {
            if let apiError = try? JSONDecoder().decode(APIError.self, from: responseData) {
                throw apiError
            }
            throw URLError(.badServerResponse)
        }
    }
    
    struct APIError: Decodable, Error {
        let message: String
        let errors: Dictionary<String, [String]>?
    }

    struct APIMessage: Decodable{
        let message: String
    }
}
