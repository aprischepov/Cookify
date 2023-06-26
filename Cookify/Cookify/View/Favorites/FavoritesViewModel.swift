//
//  FavoritesViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 21.06.23.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    //    MARK: - Properties
    @Published var favoriteRecipes: [FavoriteRecipe] = []
    let subject: PassthroughSubject<ActionsWithRecipes, Never>
    
//    MARK: - Init
    init(subject: PassthroughSubject<ActionsWithRecipes, Never>) {
        self.subject = subject
    }
    
    //    MARK: - Methods
    
    func removeFavriteRecipe(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        subject.send(.changeFromFavoritesRecipes(recipe: favoriteRecipes[index]))
    }      
}
