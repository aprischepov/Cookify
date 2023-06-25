//
//  MainViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 23.06.23.
//

import SwiftUI
import Combine

enum ActionsWithRecipes {
    case removeFromFavoritesRecipes(recipe: FavoriteRecipe)
    case addToFavoritesRecipes(recipe: FavoriteRecipe)
    case getRecipes(type: RecipeType)
    case changedTypeGetNewRecipes(type: RecipeType)
}

final class MainViewModel: ObservableObject {
    //    MARK: - Properties
    var subject = PassthroughSubject<ActionsWithRecipes, Never>()
    var user = AuthorizedUser.shared
    var cancellable = Set<AnyCancellable>()
    private var firebaseManager: FirebaseProtocol = FirebaseManager()
    private var moyaManager: MoyaManagerProtocol = MoyaManager()
    @Published var homeViewModel: HomeViewModel
    @Published var favoritesViewModel: FavoritesViewModel
    //    Recipe Properties
    @Published var fullListRecipes: [Recipe] = [] {
        didSet {
            countRecipesOffset = fullListRecipes.count
        }
    }
    private var countRecipesOffset: Int = 0
    private var countLoadingRecipes: Int = 20
    private var countRecipes: Int = 0 {
        didSet {
            let newData = countRecipes - fullListRecipes.count
            if newData < countLoadingRecipes {
                countLoadingRecipes = newData
            }
        }
    }
    @Published var favoriteRecipes: [FavoriteRecipe] = []
    //    View Properties
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var showError: Bool = false
    
    //    MARK: Init
    init() {
        
        self.homeViewModel = HomeViewModel(subject: subject)
        self.favoritesViewModel = FavoritesViewModel(subject: subject)
        
        $fullListRecipes
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.fullListRecipes, on: homeViewModel)
            .store(in: &cancellable)
        
        $favoriteRecipes
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.favoriteRecipes, on: favoritesViewModel)
            .store(in: &cancellable)
        
        subject.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .removeFromFavoritesRecipes(recipe: let recipe):
                self.removeFromFavorites(recipe: recipe)
            case .addToFavoritesRecipes(recipe: let recipe):
                self.addRecipeToFavorites(recipe: recipe)
            case .getRecipes(type: let type):
                self.getFullListRecipes(type: type)
            case .changedTypeGetNewRecipes(type: let type):
                self.getNewRecipes(type: type)
            }
        }.store(in: &cancellable)
    }
    
    //    MARK: - Methods
    //    Get All Data With Strating App
    func getAllData() async {
        guard fullListRecipes.isEmpty else { return }
        Task {
            async let _: () = fetchUserData()
            async let _: () = getFavoritesRecipes()
            async let _: () =  getFullListRecipes(type: .mainCourse)
        }
        await MainActor.run(body: {
            homeViewModel.dataCondition = .loaded
        })
    }
    
    //    Fetch User Data
    private func fetchUserData() {
        Task {
            do {
                try await firebaseManager.fetchUser()
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Get List With Favorites Recipes
    private func getFavoritesRecipes() {
        Task {
            do {
                let fetchedFavoritesRecipes = try await firebaseManager.fetchFavoritesRecipes()
                await MainActor.run(body: {
                    favoriteRecipes = fetchedFavoritesRecipes
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Get Full List Recipes
    private func getFullListRecipes(type: RecipeType) {
        Task {
            do {
                let recipesFromApi = try await moyaManager.getRecipesByType(type: type, count: countLoadingRecipes, offset: countRecipesOffset)
                let recipes = recipesFromApi.results.map{ Recipe(isFavorite: isFavoriteRecipe(id: $0.id), veryPopular: $0.veryPopular, healthScore: $0.healthScore, id: $0.id, title: $0.title, readyInMinutes: $0.readyInMinutes, servings: $0.servings, image: $0.image, pricePerServing: $0.pricePerServing) }
                await MainActor.run(body: {
                    countRecipes = recipes.count
                    fullListRecipes.append(contentsOf: recipes)
                    homeViewModel.dataCondition = .loaded
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Get Recipes With Another Type
    private func getNewRecipes(type: RecipeType) {
        fullListRecipes.removeAll()
        Task {
            getFullListRecipes(type: type)
        }
    }
    
    //    Add Recipe to Favorites
    private func addRecipeToFavorites(recipe: FavoriteRecipe) {
        Task {
            do {
                let uid = try await firebaseManager.addToFavorites(recipe: recipe)
                let favoriteRecipe = FavoriteRecipe(uid: uid, veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing)
                await MainActor.run(body: {
                    favoriteRecipes.append(favoriteRecipe)
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Remove Recipe from Favorites
    func removeFromFavorites(recipe: FavoriteRecipe) {
        let selectedRecipe = favoriteRecipes.first{ $0.id == recipe.id }
        guard let selectedRecipe = selectedRecipe else { return }
        Task {
            do {
                try await firebaseManager.deleteFromFavorites(recipe: selectedRecipe)
                await MainActor.run(body: {
                    favoriteRecipes.removeAll{ $0.id == selectedRecipe.id }
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Compare Recipe Id and Favorite Recipe
    private func isFavoriteRecipe(id: Int) -> Bool {
        favoriteRecipes.contains { $0.id == id }
    }
    
    //    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
