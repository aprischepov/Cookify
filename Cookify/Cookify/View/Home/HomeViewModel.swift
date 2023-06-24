//
//  HomeViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation

final class HomeViewModel: ObservableObject {
//    MARK: - Properties
    private let moyaManager: MoyaManagerProtocol = MoyaManager()
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var authorizedUser = AuthorizedUser.shared
//    View Properties
    @Published var searchText: String = ""
    @Published var dataCondition: DataCondition = .loading
    @Published var currentTypeRecipes: RecipeType = RecipeType.mainCourse 
    @Published var showError: Bool = false
    @Published var showSearch: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    //    Recipes Properties
    @Published var listFavoritesRecipes: [FavoriteRecipe] = []
    @Published var listRecipes: [RecipeByType] = [] {
        didSet {
            offset = listRecipes.count
        }
    }
    private var countRecipesByType: Int = 0 {
        didSet {
            let newData = countRecipesByType - listRecipes.count
            if newData >= 20 {
                number = 20
            } else {
                number = newData
            }
        }
    }
    private var offset: Int = 0
    private var number: Int = 20
    
//    MARK: - Methods
//    Get Recipes By Type
    func getRecipesByType() async {
        Task {
            do {
                let recipes = try await moyaManager.getRecipesByType(type: currentTypeRecipes, count: number, offset: offset)
                await MainActor.run(body: {
                    countRecipesByType = recipes.totalResults
                    listRecipes.append(contentsOf: recipes.results)
                    dataCondition = .loaded
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
//    Fetch User Data
    func fetchUserData() async {
        Task {
            do {
                try await firebaseManager.fetchUser()
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    func getMoreRecipesButtonAction(type: RecipeType) {
        listRecipes.removeAll()
        dataCondition = .loading
        currentTypeRecipes = type
        Task {
            await getRecipesByType()
        }
    }
    
    func getAllDataWithStartApp() async {
        if !listRecipes.isEmpty { return }
        await MainActor.run {
            dataCondition = .loading
        }
        await fetchUserData()
        await fetchFavoritesRecipes()
        await getRecipesByType()
    }
    
//    Errors
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
    
//    Add Recipe to Favorites
    func addRecipeToFavorites(recipe: FavoriteRecipe) {
        Task {
            do {
                let uid = try await firebaseManager.addToFavorites(recipe: recipe)
                let favoriteRecipe = FavoriteRecipe(uid: uid, veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing)
                await MainActor.run(body: {
                    listFavoritesRecipes.append(favoriteRecipe)
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
//    Fetch Favorites Recipes
    func fetchFavoritesRecipes() async {
        Task {
            do {
                let fetchedRecipes = try await firebaseManager.fetchFavoritesRecipes()
                await MainActor.run(body: {
                    listFavoritesRecipes = fetchedRecipes
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
//    Search Favorites
    func searchById(id: Int) -> Bool {
        listFavoritesRecipes.contains { $0.id == id }
    }
    
//    Remove Recipe from Favorites
    func removeFromFavorites(recipe: FavoriteRecipe) {
        let selectedRecipe = listFavoritesRecipes.first{ $0.id == recipe.id }
        guard let recipeSelect = selectedRecipe else { return }
        Task {
            do {
                try await firebaseManager.deleteFromFavorites(recipe: recipeSelect)
                await MainActor.run(body: {
                    listFavoritesRecipes.removeAll{ $0.id == recipeSelect.id }
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
}

enum DataCondition {
    case loading
    case loaded
}
