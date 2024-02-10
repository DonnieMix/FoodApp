//
//  RapidAPIService.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation

class RapidAPIService: NetworkServiceProtocol {
    
    private static let apiKey = "" // removed for security reasons
    private static let host = "https://api.spoonacular.com"
    
    static let shared = RapidAPIService()
    
    private var networkService: NetworkService = AFNetworkService.shared // URLSessionNetworkService.shared
    
    private init() {}
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        self.isInternetAvailable { available in
            if !available {
                completion(.failure(.internetError))
            } else {
                let url: String
                var parameters: [String: Any] = [:]
                
                switch endpoint {
                case .searchRecipes(let query):
                    url = "\(RapidAPIService.host)/recipes/complexSearch"
                    parameters["query"] = query
                case .getRecipeInformation(let recipeId):
                    url = "\(RapidAPIService.host)/recipes/\(recipeId)/information"
                case .guessNutritionByDishName(let dishName):
                    url = "\(RapidAPIService.host)/recipes/guessNutrition"
                    parameters["title"] = dishName
                case .classifyCuisine(let title, let ingredientList):
                    url = "\(RapidAPIService.host)/recipes/cuisine/?apiKey=\(RapidAPIService.apiKey)"
                    parameters["title"] = title
                    parameters["ingredientList"] = ingredientList.joined(separator: "\n")
                }
                
                switch endpoint {
                case .classifyCuisine(_, _):
                    self.networkService.post(url: url, parameters: parameters) { result in
                        switch result {
                        case .success(let data):
                            do {
                                let decodedData = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(decodedData))
                            } catch {
                                completion(.failure(.decodingError))
                            }
                        case .failure(_):
                            completion(.failure(.classificationError))
                        }
                    }
                case .guessNutritionByDishName(_):
                    parameters["apiKey"] = RapidAPIService.apiKey
                    self.networkService.get(url: url, parameters: parameters) { result in
                        switch result {
                        case .success(let data):
                            do {
                                let decodedData = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(decodedData))
                            } catch {
                                do {
                                    let _ = try JSONDecoder().decode(NutritionError.self, from: data)
                                    completion(.failure(.guessNutritionError))
                                }
                                catch {
                                    completion(.failure(.decodingError))
                                }
                            }
                        case .failure(_):
                            completion(.failure(.guessNutritionError))
                        }
                    }
                default:
                    parameters["apiKey"] = RapidAPIService.apiKey
                    self.networkService.get(url: url, parameters: parameters) { result in
                        switch result {
                        case .success(let data):
                            do {
                                let decodedData = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(decodedData))
                            } catch {
                                completion(.failure(.decodingError))
                            }
                        case .failure(let error):
                            if let aferror = error.asAFError,
                               let responseCode = aferror.responseCode {
                                completion(.failure(.serverError(responseCode)))
                            } else {
                                completion(.failure(.unknown))
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func isInternetAvailable(completion: @escaping (Bool) -> Void) {
        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (_, _, error) in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
    }

}
