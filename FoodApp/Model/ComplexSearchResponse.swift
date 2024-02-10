//
//  SearchResponse.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 02.10.2023.
//

import Foundation

struct ComplexSearchResponse: Codable {
    var results: [BriefRecipe]?
    var offset: Int
    var number: Int
    var totalResults: Int
}
struct BriefRecipe: Codable {
    var id: Int
    var title: String
    var image: String
}


