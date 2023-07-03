//
//  ListIngredientsView.swift
//  Cookify
//
//  Created by Artem Prishepov on 1.07.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct IngredientsListView: View {
    @StateObject var vm: IngredientsListViewModel
    
    init(recipe: RecipeForShopping) {
        _vm = StateObject(wrappedValue: IngredientsListViewModel(recipe: recipe))
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                WebImage(url: URL(string: vm.recipe.image)).placeholder{
                    Image("cookifyIcon")
                        .opacity(0.3)
                        .frame(maxWidth: .infinity, maxHeight: 320, alignment: .center)
                }
                .resizable()
                .scaledToFit()
                .frame(height: 320)
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.jost(.bold, size: .title))
                    ForEach(vm.recipe.ingredients, id: \.id) { ingredient in
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(ingredient.name)
                                    .foregroundColor(.customColor(.black))
                                Text(ingredient.amountWithUnits)
                                    .foregroundColor(.customColor(.gray))
                            }
                            .font(.jost(.regular, size: .body))
                            Spacer()
                            Button {
                                    vm.changeMissingIngredients(ingredient: ingredient)
                            } label: {
                                Image(systemName: ingredient.selected ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(ingredient.selected ? .customColor(.orange) : .customColor(.gray))
                            }
                        }
                        Divider()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.top)
        .navigationTitle(vm.recipe.title)
    }
}

struct ListIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsListView(recipe: RecipeForShopping(id: 1234, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg", title: "Cannellini Bean", ingredients: [IngredientShopping(id: 1, name: "Pasta", amountWithUnits: "1 kg", selected: false), IngredientShopping(id: 2, name: "Garlic", amountWithUnits: "0.5 kg", selected: true)]))
    }
}
