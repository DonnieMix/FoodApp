//
//  Recipe.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation

struct Recipe: Codable {
    var title: String
    var image: String
    var readyInMinutes: Int
    var servings: Int
    var sourceUrl: String
    var cuisines: [String]
    var diets: [String]
    var instructions: String
    var extendedIngredients: [ExtendedIngredient]
}

struct ExtendedIngredient: Codable {
    var id: Int
    var name: String
    var amount: Double
    var unit: String
    var original: String
}
