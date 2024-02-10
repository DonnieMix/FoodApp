//
//  NetworkError.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 03.10.2023.
//

import Foundation

enum NetworkError: Error {
    case internetError
    case requestFailed(Error)
    case decodingError
    case classificationError
    case guessNutritionError
    case serverError(Int)
    case unknown
}
