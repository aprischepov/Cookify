//
//  RecipesByType.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation

struct RecipesByTypeData: Decodable {
    let results: [RecipesByType]
    let totalResults: Int
}

struct RecipesByType: Decodable {
    let veryPopular: Bool
    let healthScore: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String
}
