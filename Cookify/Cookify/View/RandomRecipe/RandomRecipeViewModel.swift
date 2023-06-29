//
//  RandomRecipeViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 28.06.23.
//

import Foundation

final class RandomRecipeViewModel: ObservableObject {
//    MARK: Properties
    private var moyaManager: MoyaManagerProtocol = MoyaManager()
    @Published var randomRecipesList: [Recipe] = []
//    View Properties
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
    init() {
        Task {
            await getrecipeRandom()
        }
    }
    
//    MARK: Methods
//    Get Random Recipe
    private func getrecipeRandom() async {
            do {
                let recipes = try await moyaManager.getRecipeRandom()
                let randomRecipes = recipes.recipes.map{ $0.transformToRecipe(isFavorite: false) }
                await MainActor.run {
                    randomRecipesList = randomRecipes
                }
            } catch {
                
            }
    }
    
//    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
