//
//  SearchByIngredientsViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 29.06.23.
//

import Foundation
import Combine

final class SearchByIngredientsViewModel: ObservableObject {
//    MARK: Properties
    private var cancellable = Set<AnyCancellable>()
    private var moyaManager: MoyaManagerProtocol = MoyaManager()
    @Published var searchResultsList: [RecipeByIngredients] = []
//    View Properties
    @Published var texfieldsList: [String] = [""]
    @Published var isButtonActivated: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
//    MARK: Init
    init() {
//        $texfieldsList
//            .sink { [weak self] _ in
//                guard let self else { return }
//                self.isButtonActivated
//            }.store(in: &cancellable)
    }
    
//    MARK: Properties
//    Add textfield
    func addTextfield() {
        texfieldsList.append("")
    }
    
//    Action Textfield
    func actionTextfield() {
        if texfieldsList.count != 1 {
            texfieldsList.removeLast()
        } 
    }
    
//    Button Activate
    private func buttonActivate() {
        guard let text = texfieldsList.first else { return }
        isButtonActivated = !text.isEmpty
    }
    
//    Get Search Results
    private func getSearchByIngredients() async {
        Task {
            do {
                let recipes = try await moyaManager.getRecipesByIngredient(ingredients: texfieldsList)
                await MainActor.run(body: {
                    searchResultsList = recipes
                })
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
