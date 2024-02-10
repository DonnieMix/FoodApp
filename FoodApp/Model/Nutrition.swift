//
//  Nutrition.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 02.10.2023.
//

import Foundation

struct Nutrition: Codable {
    var calories: NutritionDetails
    var fat: NutritionDetails
    var protein: NutritionDetails
    var carbs: NutritionDetails
}
struct NutritionDetails: Codable {
    var value: Double
    var unit: String
}

extension NutritionDetails: CustomStringConvertible {
    var description: String { return "\(value) \(unit)" }
}

struct NutritionError: Codable {
    var status: String
    var message: String
}
