//
//  FavoritesCard.swift
//  Cookify
//
//  Created by Artem Prishepov on 21.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteRecipeCard: View {
    var recipe: FavoriteRecipe
    var body: some View {
            HStack(alignment: .center, spacing: 8) {
                //                Recipe's Image
                WebImage(url: URL(string: recipe.image)).placeholder {
                    Image("cookifyIcon")
                        .opacity(0.3)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 136, height: 136)
                .clipped()
                .cornerRadius(10)
                //                Recipe's Information
                VStack(alignment: .leading, spacing: 4) {
                    //                    Title
                    Text(recipe.title)
                        .font(.jost(.medium, size: .body))
                    //                    Health Score
                    HStack(alignment: .center, spacing: 4) {
                        Text("Health score:")
                            .foregroundColor(.customColor(.orange))
                        Text("\(recipe.healthScore) %")
                            .foregroundColor(.customColor(.gray))
                    }
                    .font(.jost(.regular, size: .body))
                    //                    Ready In Minutes
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.customColor(.orange))
                        Text("\(recipe.readyInMinutes) min")
                            .font(.jost(.regular, size: .footnote))
                            .foregroundColor(.customColor(.gray))
                    }
                    //                    Count Servings
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "person.2")
                            .foregroundColor(.customColor(.orange))
                        Text("\(recipe.servings) people")
                            .font(.jost(.regular, size: .footnote))
                            .foregroundColor(.customColor(.gray))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FavoritesCard_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRecipeCard(recipe: FavoriteRecipe(veryPopular: false, healthScore: 100, id: 12345, title: "Cannellini Bean", readyInMinutes: 45, servings: 6, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg", pricePerServing: 10.00))
    }
}
