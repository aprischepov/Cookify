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
//    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var favoriteRecipes: [FavoriteRecipe] = []
    let subject: PassthroughSubject<ActionsWithRecipes, Never>
    //    View Properties
//    @Published var errorMessage: String = "" {
//        didSet {
//            showError.toggle()
//        }
//    }
//    @Published var showError: Bool = false
    
//    MARK: - Init
    init(subject: PassthroughSubject<ActionsWithRecipes, Never>) {
        self.subject = subject
    }
    
    //    MARK: - Methods
    
    func removeFavriteRecipe(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        subject.send(.removeFromFavoritesRecipes(recipe: favoriteRecipes[index]))
    }
    
//    func sendIndexRecipes(index: IndexSet) {
////        favoriteRecipes.first{ $0.in }
//        subject.send(index)
//    }
    
    //    Fetch Recipes From Firebase
//    func fetchRecipes() async {
//        Task {
//            do {
//                let fetchedRecipes = try await firebaseManager.fetchFavoritesRecipes()
//                await MainActor.run {
//                    likedRecipes = fetchedRecipes
//                }
//            } catch {
//                await errorHandling(error)
//            }
//        }
//    }
//
    //    Errors
//    private func errorHandling(_ error: Error) async {
//        await MainActor.run(body: {
//            errorMessage = error.localizedDescription
//        })
//    }
//
//    Remove Favorite Recipe
//    func removeRecipe(index: IndexSet.Element) {
//        let removedRecipe = listFavoritesRecipes[index]
//        Task {
//            do {
//                try await firebaseManager.deleteFromFavorites(recipe: removedRecipe)
//            } catch {
//                await errorHandling(error)
//            }
//        }
//    }
}
