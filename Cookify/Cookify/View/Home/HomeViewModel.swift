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
    @Published var userProfile: User?
    @Published var searchText: String = ""
    @Published var currentTypeRecipes: RecipeType = (RecipeType.allCases.first ?? .mainCourse)
    @Published var showError: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    //    For list recipes
    @Published var listRecipes: [RecipeByType] = [] {
        didSet {
            offset = listRecipes.count
            let newData = countRecipesByType - listRecipes.count
            if newData >= 20 {
                number = 20
            } else {
                number = newData
            }
            isLoadingNewData = false
        }
    }
    @Published var isLoadingNewData: Bool = false
    private var countRecipesByType: Int = 0
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
                    isLoadingNewData = false
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
                let user = try await firebaseManager.fetchUser()
                await MainActor.run(body: {
                    userProfile = user
                })
            } catch {
                await errorHandling(error)
            }
        }
    }
    
//    Errors
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
