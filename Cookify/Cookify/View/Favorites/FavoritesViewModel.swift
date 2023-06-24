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
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var listFavoritesRecipes: [FavoriteRecipe] = []
    let subject = PassthroughSubject<IndexSet, Error>()
    //    View Properties
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
    //    MARK: - Methods
    
    func sendIndexRecipes(index: IndexSet) {
        subject.send(index)
    }
    
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
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
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
