//
//  RecipesByType.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation

struct RecipesByTypeData: Decodable {
    let results: [RecipeByType]
    let totalResults: Int
}

struct RecipeByType: Decodable {
    let veryPopular: Bool
    let healthScore: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
}
