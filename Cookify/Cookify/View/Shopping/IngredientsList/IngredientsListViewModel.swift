//
//  IngredientsListViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 2.07.23.
//

import Foundation

final class IngredientsListViewModel: ObservableObject {
//    MARK: - Properties
    private var firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var recipe: RecipeForShopping
//    View Properties
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
//    MARK: Init
    init(recipe: RecipeForShopping) {
        self.recipe = recipe
    }
    
//    MARK: Methods
//    Cross Out the Ingredient
    func changeMissingIngredients(ingredient: IngredientShopping) {
        Task {
            do {
                await MainActor.run {
                    guard let index = recipe.ingredients.firstIndex(where: { $0.id == ingredient.id }) else { return }
                    var changedIngredient = recipe.ingredients.remove(at: index)
                    changedIngredient.selected.toggle()
                    recipe.ingredients.insert(changedIngredient, at: index)
                    recipe.ingredients.sort(by: { !$0.selected && $1.selected })
                }
                try await firebaseManager.updateShoppingList(recipe: recipe)
            } catch {
                await errorHandling(error)
            }
        }
    }
    
//    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
    
}
