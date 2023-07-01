//
//  ShoppingViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 1.07.23.
//

import Foundation

final class ShoppingViewModel: ObservableObject {
//    MARK: Properties
    @Published var shoppingList: [RecipeForShopping] = [RecipeForShopping(id: 1234, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg", title: "Cannellini Bean", ingredients: [IngredientShopping(id: 1, name: "Pasta", amountWithUnits: "1 kg", selected: false), IngredientShopping(id: 2, name: "Garlic", amountWithUnits: "0.5 kg", selected: false)]), RecipeForShopping(id: 12345, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg", title: "Cannellini Bean and fry popatoes with srimps and garlic", ingredients: [IngredientShopping(id: 1, name: "Pasta", amountWithUnits: "1 kg", selected: false)])]
//    MARK: Init
    
//    MARK: Methods
//    Remove Recipe from Shopping List
    func removeRecipe(indexSet: IndexSet) {
        shoppingList.remove(atOffsets: indexSet)
    }
}

struct RecipeForShopping {
    var id: Int
    var image: String
    var title: String
    var ingredients: [IngredientShopping]
}

struct IngredientShopping {
    var id: Int
    var name: String
    var amountWithUnits: String
    var selected: Bool
}
