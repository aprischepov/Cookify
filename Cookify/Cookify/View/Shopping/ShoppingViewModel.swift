//
//  ShoppingViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 1.07.23.
//

import Foundation
import Combine

final class ShoppingViewModel: ObservableObject {
    //    MARK: Properties
    private var firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var shoppingList: [RecipeForShopping] = []
    //    View Properties
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
    //    MARK: Methods
    //    Get to Shopping List
    func fetchShoppingList() async {
        Task {
            do {
                let fetchedRecipes = try await firebaseManager.fetchShoppingList()
                await MainActor.run {
                    shoppingList = fetchedRecipes
                }
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    //    Remove From Shopping List
    func removeFromShoppingList(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        Task {
            do {
                try await firebaseManager.removeFromShoppingList(recipe: shoppingList[index])
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
