//
//  HomeViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 24.06.23.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    //    MARK: - Properties
    let subject: PassthroughSubject<ActionsWithRecipes, Never>
    @Published var user: AuthorizedUser
//    Recipe Properties
    @Published var fullListRecipes: [Recipe] = []
    @Published var currentTypeRecipes: RecipeType = RecipeType.mainCourse
//    View Properties
    @Published var showSearch: Bool = false
    @Published var dataCondition: DataCondition = .loading
    
    //    MARK: - Init
    init(subject: PassthroughSubject<ActionsWithRecipes, Never>, user: AuthorizedUser) {
        self.subject = subject
        self.user = user
    }
    //    MARK: - Methods
    func sendAction(actionType: ActionsWithRecipes) {
        switch actionType {
        case .changeFromFavoritesRecipes(let recipe):
            subject.send(.changeFromFavoritesRecipes(recipe: recipe))
        case .getRecipes(let type):
            subject.send(.getRecipes(type: type))
            dataCondition = .loading
        case .changedTypeGetNewRecipes(type: let type):
            subject.send(.changedTypeGetNewRecipes(type: type))
            currentTypeRecipes = type
            dataCondition = .loading
        }
    }
    
    func sendFavoriteRecipe(recipe: Recipe) {
        let favoriteRecipe = FavoriteRecipe(veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing)
        sendAction(actionType: .changeFromFavoritesRecipes(recipe: favoriteRecipe))
    }
}

enum DataCondition {
    case loading
    case loaded
}
