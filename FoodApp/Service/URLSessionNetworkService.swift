//
//  URLSessionNetworkService.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 03.10.2023.
//

import Foundation

class URLSessionService: NetworkService {
    static let shared = URLSessionService()
    
    private init() {}
    
    func get(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard var components = URLComponents(string: url) else {
            completion(.failure(.unknown))
            return
        }
        if let parameters = parameters {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        guard let finalURL = components.url else {
            completion(.failure(.unknown))
            return
        }
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func post(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters,
           let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            request.httpBody = httpBody
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
