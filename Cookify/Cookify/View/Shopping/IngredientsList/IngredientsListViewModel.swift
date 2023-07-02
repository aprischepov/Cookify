//
//  IngredientsListViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 2.07.23.
//

import Foundation

final class IngredientsListViewModel: ObservableObject {
    @Published var recipe: RecipeForShopping
    
    init(recipe: RecipeForShopping) {
        self.recipe = recipe
    }
}
