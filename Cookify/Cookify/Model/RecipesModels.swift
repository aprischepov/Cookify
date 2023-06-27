//
//  RecipesByType.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Recipe: Codable {
    @DocumentID var uid: String?
    var isFavorite: Bool
    let veryPopular: Bool
    let healthScore: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
    let pricePerServing: Double
}

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
    let pricePerServing: Double
}

struct RecipesByQuery: Decodable {
    let id: Int
    let title: String
    let imageType: String
}

struct RecipeById: Decodable {
    let id: Int
    let title: String
    let imageUrl: String
    let readyInMinutes: Int
    let healthScore: Int
    let servings: Int
    let summary: String
    let analyzedInstructions: [AnalyzedInstructions]
    let extendedIngredients: [Ingredient]
    let nutrition: Nutrition
}

struct Nutrition: Decodable {
    let nutrients: [Nutrients]
}

struct Nutrients: Decodable {
    let name: String
    let amount: Int
}

struct Ingredient: Decodable {
    let id: Int
    let name: String
    let measures: Measures
}
struct Measures: Decodable {
    let metric: Metric
}
struct Metric: Decodable {
    let amount: Int
    let unitShort: String
}

struct AnalyzedInstructions: Decodable {
    let steps: [Steps]
}

struct Steps: Decodable {
    let number: Int
    let step: String
}
