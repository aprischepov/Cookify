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
//    Recipe Properties
    @Published var fullListRecipes: [Recipe] = []
    @Published var currentTypeRecipes: RecipeType = RecipeType.mainCourse
//    View Properties
    @Published var showSearch: Bool = false
    @Published var dataCondition: DataCondition = .loading
    
    //    MARK: - Init
    init(subject: PassthroughSubject<ActionsWithRecipes, Never>) {
        self.subject = subject
    }
    //    MARK: - Methods
    func sendAction(actionType: ActionsWithRecipes) {
        switch actionType {
        case .removeFromFavoritesRecipes(let recipe):
            subject.send(.removeFromFavoritesRecipes(recipe: recipe))
        case .addToFavoritesRecipes(let recipe):
            subject.send(.addToFavoritesRecipes(recipe: recipe))
        case .getRecipes(let type):
            subject.send(.getRecipes(type: type))
            dataCondition = .loading
        case .changedTypeGetNewRecipes(type: let type):
            subject.send(.changedTypeGetNewRecipes(type: type))
            currentTypeRecipes = type
            dataCondition = .loading
        }
    }
}

enum DataCondition {
    case loading
    case loaded
}
