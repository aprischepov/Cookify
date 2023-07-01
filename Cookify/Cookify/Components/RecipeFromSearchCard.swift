//
//  RecipeFromSearchCard.swift
//  Cookify
//
//  Created by Artem Prishepov on 29.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeFromSearchCard: View {
    @State private var showMissedIngredients: Bool = false
    var recipe: RecipeByIngredients
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
//            Recipe Image
            WebImage(url: URL(string: recipe.image)).placeholder{
                ZStack {
                    Image("cookifyIcon")
                        .opacity(0.3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .resizable()
            .scaledToFit()
            .layoutPriority(1)
//            Recipe Title
            Text(recipe.title)
                .font(.jost(.medium, size: .title))
                .foregroundColor(.customColor(.black))
                .multilineTextAlignment(.leading)
                .lineLimit(2, reservesSpace: true)
                .padding(.horizontal, 16)
//            Missed Ingredients
            HStack(alignment: .center) {
                DisclosureGroup("Missed ingredients: \(recipe.missedIngredientCount)") {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(recipe.missedIngredients, id: \.id) { ingredient in
                            HStack {
                                Text("\(Int(ingredient.amount)) \(ingredient.unit)")
                                    .foregroundColor(.customColor(.gray))
                                Text(ingredient.name)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.jost(.regular, size: .body))
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct RecipeFromSearchCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFromSearchCard(recipe: RecipeByIngredients(id: 1, title: "Xocai Healthy Chocolate Peanut Butter Bannana Dip", image: "https://spoonacular.com/recipeImages/665469-312x231.jpg", missedIngredientCount: 2, missedIngredients: [MissedIngredient(id: 1, amount: 1.0, unit: "", name: "chocolate"), MissedIngredient(id: 2, amount: 1.0, unit: "tbsp", name: "peanut butter")]))
    }
}
