//
//  SearchByIngredientsViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 29.06.23.
//

import Foundation
import Combine

struct TextfieldModel: Identifiable {
    let id = UUID()
    var text: String
}

final class SearchByIngredientsViewModel: ObservableObject {
    //    MARK: Properties
    private var cancellable = Set<AnyCancellable>()
    private var moyaManager: MoyaManagerProtocol = MoyaManager()
    @Published var searchResultsList: [RecipeByIngredients] = []
    //    View Properties
    @Published var textfieldModels: [TextfieldModel] = [TextfieldModel(text: "")]
    @Published var isButtonActivated: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    @Published var dataCondition: DataCondition = .loaded
    
    //    MARK: Init
    
    init() {
        $textfieldModels
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.buttonActivate()
                }
            }.store(in: &cancellable)
    }
    
    //    MARK: Properties
    //    Add textfield
    func addTextfield() async {
        await MainActor.run {
            textfieldModels.append(TextfieldModel(text: ""))
        }
    }
    
    //    Send response and Check Textfields
    func findRecipesButtonAction() async {
        let emptytext = textfieldModels.filter{ $0.text.isEmpty }
        await MainActor.run(body: {
            textfieldModels.removeAll(where: { $0.id == emptytext.first?.id })
            dataCondition = .loading
        })
        let ingredients = textfieldModels.map{ $0.text }
        await getSearchByIngredients(ingredients: ingredients)
    }
    
    //    Button Activate
    private func buttonActivate() async {
        guard let text = textfieldModels.first?.text else { return }
        await MainActor.run(body: {
            isButtonActivated = !text.isEmpty
        })
    }
    
    //    Get Search Results
    private func getSearchByIngredients(ingredients: [String]) async {
        //        Task {
        do {
            let recipes = try await moyaManager.getRecipesByIngredient(ingredients: ingredients)
            await MainActor.run(body: {
                if recipes.isEmpty {
                    dataCondition = .empty
                } else {
                    searchResultsList = recipes
                    dataCondition = .loaded
                }
            })
        } catch {
            await errorHandling(error)
        }
        //        }
    }
    
    //    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
    
    deinit {
        cancellable.removeAll()
    }
}
