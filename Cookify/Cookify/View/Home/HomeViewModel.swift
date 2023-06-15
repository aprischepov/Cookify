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
    @Published var listRecipes: [RecipesByTypeData] = []
    @Published var userProfile: User?
    @Published var showError: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    
//    MARK: - Methods
//    Get Recipes By Type
    func getRecipesByType(type: RecipeType, count: Int) async throws -> RecipesByTypeData {
        try await moyaManager.getRecipesByType(type: type, count: count)
    }
    
//    Fetch User Data
    func fetchUserData() async {
        Task {
            do {
                let user = try await firebaseManager.fetchUser()
                await MainActor.run(body: {
                    userProfile = user
                })
            } catch {
                await errorFetchUser(error)
            }
        }
    }
    
//    Errors
    private func errorFetchUser(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
