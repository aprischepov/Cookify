//
//  MainViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 23.06.23.
//

import SwiftUI
import Combine

enum ActionsWithRecipes {
    case changeFromFavoritesRecipes(recipe: Recipe)
    case getRecipes(type: RecipeType)
    case changedTypeGetNewRecipes(type: RecipeType)
}

final class MainViewModel: ObservableObject {
    //    MARK: - Properties
    var subject = PassthroughSubject<ActionsWithRecipes, Never>()
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
    @Published var favoriteRecipes: [Recipe] = []
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
            case .changeFromFavoritesRecipes(recipe: let recipe):
                self.changeRecipeFromFavorites(recipe: recipe)
            case .getRecipes(type: let type):
                Task {
                    await self.getFullListRecipes(type: type)
                }
            case .changedTypeGetNewRecipes(type: let type):
                self.getNewRecipes(type: type)
            }
        }.store(in: &cancellable)
    }
    
    //    MARK: - Methods
    //    Get All Data With Strating App
    func getAllData() async {
        guard fullListRecipes.isEmpty else { return }
        await fetchUserData()
        await getFavoritesRecipes()
        await getFullListRecipes(type: .mainCourse)
        await MainActor.run(body: {
            homeViewModel.dataCondition = .loaded
        })
    }
    
    //    Fetch User Data
    private func fetchUserData() async {
        do {
            try await firebaseManager.fetchUser()
        } catch {
            await errorHandling(error)
        }
    }
    
    //    Get List With Favorites Recipes
    private func getFavoritesRecipes() async {
        do {
            let fetchedFavoritesRecipes = try await firebaseManager.fetchFavoritesRecipes()
            await MainActor.run(body: {
                favoriteRecipes = fetchedFavoritesRecipes
            })
        } catch {
            await errorHandling(error)
        }
    }
    
    //    Get Full List Recipes
    private func getFullListRecipes(type: RecipeType) async {
        do {
            let recipesFromApi = try await moyaManager.getRecipesByType(type: type, count: countLoadingRecipes, offset: countRecipesOffset)
            let recipes = recipesFromApi.results.map{ $0.transformToRecipe(isFavorite: isFavoriteRecipe(id: $0.id)) }
            await MainActor.run(body: {
                countRecipes = recipes.count
                fullListRecipes.append(contentsOf: recipes)
                homeViewModel.dataCondition = .loaded
            })
        } catch {
            await errorHandling(error)
        }
    }
    
    //    Get Recipes With Another Type
    private func getNewRecipes(type: RecipeType) {
        fullListRecipes.removeAll()
        countLoadingRecipes = 20
        Task {
            await getFullListRecipes(type: type)
        }
    }
    
//    Remove / Add to Favorites Recipe
    private func changeRecipeFromFavorites(recipe: Recipe) {
        guard let index = fullListRecipes.firstIndex(where: { $0.id == recipe.id }) else { return }
        let isFavoriteRecipe = isFavoriteRecipe(id: recipe.id)
        var changedRecipe = fullListRecipes.remove(at: index)
        changedRecipe.isFavorite.toggle()
        fullListRecipes.insert(changedRecipe, at: index)
        switch isFavoriteRecipe {
        case true:
            removeFromFavorites(recipe: recipe)
        case false:
            addRecipeToFavorites(recipe: recipe)
        }
    }
    
    //    Add Recipe to Favorites
    private func addRecipeToFavorites(recipe: Recipe) {
        Task {
            do {
                var changedRecipe = recipe
                changedRecipe.isFavorite.toggle()
                let uid = try await firebaseManager.addToFavorites(recipe: changedRecipe)
                let favoriteRecipe = Recipe(uid: uid, isFavorite: true, veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing)
                await MainActor.run(body: {
                    favoriteRecipes.append(favoriteRecipe)
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Remove Recipe from Favorites
    private func removeFromFavorites(recipe: Recipe) {
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
    
    //    MARK: Deinit
    deinit {
        cancellable.removeAll()
    }
}
