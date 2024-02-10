//
//  AFNetworkService.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation

protocol NetworkService {
    func get(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func post(url: String, parameters: [String: Any]?, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
