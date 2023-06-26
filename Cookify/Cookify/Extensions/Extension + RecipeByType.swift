//
//  Extension + RecipeByType.swift
//  Cookify
//
//  Created by Artem Prishepov on 26.06.23.
//

import Foundation

extension RecipeByType {
    func transfromToRecipe(isFavorite: Bool) -> Recipe {
        Recipe(isFavorite: isFavorite, veryPopular: self.veryPopular, healthScore: self.healthScore, id: self.id, title: self.title, readyInMinutes: self.readyInMinutes, servings: self.servings, image: self.image, pricePerServing: self.pricePerServing)
    }
}
