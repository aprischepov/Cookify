//
//  SubmittedRecipes.swift
//  Cookify
//
//  Created by Artem Prishepov on 22.06.23.
//

import Foundation
import FirebaseFirestoreSwift

struct FavoriteRecipe: Codable {
    @DocumentID var uid: String?
    let veryPopular: Bool
    let healthScore: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
    let pricePerServing: Double
}
