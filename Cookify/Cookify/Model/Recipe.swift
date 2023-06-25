//
//  Recipe.swift
//  Cookify
//
//  Created by Artem Prishepov on 24.06.23.
//

import Foundation

struct Recipe {
    var isFavorite: Bool
    var veryPopular: Bool
    var healthScore: Int
    var id: Int
    var title: String
    var readyInMinutes: Int
    var servings: Int
    var image: String
    var pricePerServing: Double
}
