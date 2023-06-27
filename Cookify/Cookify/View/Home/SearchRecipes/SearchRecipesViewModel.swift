//
//  SearchRecipesViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 20.06.23.
//

import Foundation
import Combine

final class SearchRecipesViewModel: ObservableObject {
    //    MARK: Properties
    private var moyaManager: MoyaManagerProtocol = MoyaManager()
    var searchCancellable = Set<AnyCancellable>()
    @Published var recipesList: [RecipesByQuery] = []
    //    View Properties
    @Published var inputSearchText: String = ""
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
    //    MARK: Init
    init() {
        $inputSearchText
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                if !text.isEmpty {
                    Task {
                        await self.getRecipesByQuery(query: text)
                    }
                } else {
                    self.recipesList.removeAll()
                }
            }.store(in: &searchCancellable)
    }
    
    //    MARK: Methods
    //    Ger Recipes by Query
    func getRecipesByQuery(query: String) async {
        do {
            let recipes = try await moyaManager.getRecipeByQuery(query: query)
            await MainActor.run(body: {
                recipesList = recipes
            })
        } catch {
            await errorHandling(error)
        }
    }
    
    //    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
    
    func getImageUrl(id: Int, typeImage: String) -> URL? {
        URL(string: "https://spoonacular.com/recipeImages/\(id)-312x231.\(typeImage)")
    }
    
    //    MARK: Deinit
    deinit {
        searchCancellable.removeAll()
    }
}
