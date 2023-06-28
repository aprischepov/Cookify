//
//  RecipeViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 27.06.23.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    //    MARK: Properties
    @Published var id: Int
    private let moyaManager: MoyaManagerProtocol = MoyaManager()
    @Published var recipeInfo: RecipeById?
    //    View Properties
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    @Published var currentType: RecipeInfoType = .ingredients
    @Published var dataCondition: DataCondition = .loading
    
    //    MARK: Init
    @MainActor
    init(id: Int) {
        self.id = id
        Task {
            if !ProcessInfo.isPreviewMode {
                recipeInfo = await getRecipeInfo()
                dataCondition = .loaded
            }
        }
    }
    
    //  MARK: Methods
    //    Get Recipe Info
    private func getRecipeInfo() async -> RecipeById? {
        do {
            return try await moyaManager.getRecipeInformationById(id: id)
        } catch {
            await errorHandling(error)
            return nil
        }
    }
    
    //    Search Nutrients
    func searchNutrients(name: String) -> Int {
        guard let recipeInfo = recipeInfo else { return 0 }
        let nutrient = recipeInfo.nutrition.nutrients.first(where: {$0.name == name})
        return Int(nutrient?.amount ?? 0)
    }
    
    //    Remove Tags
    func convertSummary(text: String) -> String {
        text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    //    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}

enum RecipeInfoType: String, CaseIterable {
    case ingredients = "Ingredients"
    case instructions = "Instructions"
    
    var id: Int {
        switch self {
        case .ingredients:
            return 0
        case .instructions:
            return 1
        }
    }
}

enum NutrientRecipes: String, CaseIterable {
    case calories = "Calories"
    case fat = "Fat"
    case protein = "Protein"
    case carbs = "Carbohydrates"
    
    var id: Int {
        switch self {
        case .calories:
            return 0
        case .fat:
            return 1
        case .protein:
            return 2
        case .carbs:
            return 3
        }
    }
    
    var icon: String {
        switch self {
        case .calories:
            return "caloriesIcon"
        case .fat:
            return "fatIcon"
        case .protein:
            return "proteinIcon"
        case .carbs:
            return "carbsIcon"
        }
    }
    
    var unit: String {
        switch self {
        case .calories:
            return "kcal"
        default:
            return "g"
        }
    }
}
