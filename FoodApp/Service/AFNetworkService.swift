//
//  AFNetworkService.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 03.10.2023.
//

import Foundation
import Alamofire

class AFNetworkService: NetworkService {
    static let shared = AFNetworkService()
    
    private init() {}
        
    func get(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(.requestFailed(error)))
                }
            }
    }
    
    func post(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(.requestFailed(error)))
                }
            }
    }
}
