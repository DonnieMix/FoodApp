//
//  Endpoint.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 03.10.2023.
//

import Foundation

enum Endpoint {
    case searchRecipes(query: String)
    case getRecipeInformation(recipeId: Int)
    case guessNutritionByDishName(dishName: String)
    case classifyCuisine(title: String, ingredientList: [String])
}
