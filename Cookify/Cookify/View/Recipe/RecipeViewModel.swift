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
    @Published var summary: String = ""
    @Published var nutrients: [NutrientModel] = []
    @Published var ingredients: [IngredientModel] = []
    @Published var steps: [Step] = []
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
    init(id: Int) {
        self.id = id
        Task {
            if !ProcessInfo.isPreviewMode {
                await getRecipeInfo()
            }
        }
    }
    
    //  MARK: Methods
    //    Get Recipe Info
    private func getRecipeInfo() async {
        do {
            let recipe = try await moyaManager.getRecipeInformationById(id: id)
//            Remove Tags
            let recipeSummary = recipe.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//            Nutrients
            await searchNutrients(recipe: recipe)
//            Ingredients
            await searchIngredients(recipe: recipe)
//            Steps
            guard let recipeInstructions = recipe.analyzedInstructions.first?.steps else { return }
            await MainActor.run(body: {
                recipeInfo = recipe
                summary = recipeSummary
                steps = recipeInstructions
                dataCondition = .loaded
            })
//            return recipe
        } catch {
            await errorHandling(error)
//            return nil
        }
    }
    
    //    Search Nutrient and Nutrient Info
    func searchNutrients(recipe: RecipeById) async {
        let calories = recipe.nutrition.nutrients.first(where: { $0.name == NutrientRecipes.calories.rawValue }).map{ NutrientModel(type: .calories, text: "\(Int($0.amount))\(NutrientRecipes.calories.unit) \(NutrientRecipes.calories.rawValue)") }
        let fat = recipe.nutrition.nutrients.first(where: { $0.name == NutrientRecipes.fat.rawValue }).map{ NutrientModel(type: .fat, text: "\(Int($0.amount))\(NutrientRecipes.fat.unit) \(NutrientRecipes.fat.rawValue)") }
        let protein = recipe.nutrition.nutrients.first(where: { $0.name == NutrientRecipes.protein.rawValue }).map{ NutrientModel(type: .protein, text: "\(Int($0.amount))\(NutrientRecipes.protein.unit) \(NutrientRecipes.protein.rawValue)") }
        let carbs = recipe.nutrition.nutrients.first(where: { $0.name == NutrientRecipes.carbs.rawValue }).map{ NutrientModel(type: .carbs, text: "\(Int($0.amount))\(NutrientRecipes.carbs.unit) \(NutrientRecipes.carbs.rawValue)") }
        guard let calories = calories,
              let fat = fat,
              let protein = protein,
              let carbs = carbs else { return }
        await MainActor.run(body: {
            nutrients.append(contentsOf: [calories, fat, protein, carbs])
        })
    }
    
//    Search Ingredient Info
    func searchIngredients(recipe: RecipeById) async {
        let recipeIngredients = recipe.extendedIngredients.compactMap { IngredientModel(name: $0.name, text: "\($0.measures.metric.amount.rounded()) \($0.measures.metric.unitShort)")}
        await MainActor.run(body: {
            ingredients = recipeIngredients
        })
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

struct NutrientModel {
    var id = UUID()
    var type: NutrientRecipes
    var text: String
}

struct IngredientModel {
    var id = UUID()
    var name: String
    var text: String
}
