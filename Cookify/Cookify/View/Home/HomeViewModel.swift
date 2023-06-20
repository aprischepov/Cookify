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
    @Published var authorizedUser = AuthorizedUser.shared
//    View Properties
    @Published var searchText: String = ""
    @Published var dataCondition: DataCondition = .loading
    @Published var updateData: Bool = true
    @Published var currentTypeRecipes: RecipeType = RecipeType.mainCourse 
    @Published var showError: Bool = false
    @Published var showSearch: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    //    Recipes Properties
    @Published var listRecipes: [RecipeByType] = [] {
        didSet {
            offset = listRecipes.count
        }
    }
    private var countRecipesByType: Int = 0 {
        didSet {
            let newData = countRecipesByType - listRecipes.count
            if newData >= 20 {
                number = 20
            } else {
                number = newData
            }
        }
    }
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
                    dataCondition = .loaded
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
                try await firebaseManager.fetchUser()
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    func getMoreRecipesButtonAction(type: RecipeType) {
        listRecipes.removeAll()
        dataCondition = .loading
        currentTypeRecipes = type
        Task {
            await getRecipesByType()
        }
    }
    
    func getAllDataWithStartApp() async {
        if !updateData { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dataCondition = .loading
            self.updateData = false
        }
        await fetchUserData()
        await getRecipesByType()
    }
    
//    Errors
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}

enum DataCondition {
    case loading
    case loaded
}
