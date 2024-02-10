//
//  NetworkServiceProtocol.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 02.10.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}
