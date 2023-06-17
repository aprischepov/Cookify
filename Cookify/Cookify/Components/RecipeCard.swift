//
//  RecipeCard.swift
//  Cookify
//
//  Created by Artem Prishepov on 16.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeCard: View {
    var recipe: RecipeByType
    @State var isFavorite: Bool = false
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 8) {
//                Recipe's Image
                WebImage(url: URL(string: recipe.image)).placeholder {
                    Image(systemName: "photo")
                        .foregroundColor(.customColor(.gray))
                    }
                    .resizable()
                    .frame(width: 112, height: 112)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
//                Recipe's Information
                VStack(alignment: .leading, spacing: 4) {
//                    Title
                    Text(recipe.title)
                        .font(.jost(.regular, size: .footnote))
//                    Health Score
                    HStack(alignment: .center, spacing: 4) {
                        Text("Health score:")
                            .font(.jost(.regular, size: .caption))
                            .foregroundColor(.customColor(.orange))
                        Text("\(recipe.healthScore) %")
                            .font(.jost(.regular, size: .caption))
                            .foregroundColor(.customColor(.gray))
                    }
//                    Ready In Minutes
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.customColor(.orange))
                        Text("\(recipe.readyInMinutes) min")
                            .font(.jost(.regular, size: .caption))
                            .foregroundColor(.customColor(.gray))
                    }
//                    Count Servings
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "person.2")
                            .foregroundColor(.customColor(.orange))
                        Text("\(recipe.servings) people")
                            .font(.jost(.regular, size: .caption))
                            .foregroundColor(.customColor(.gray))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 144)
        .background(Color.customColor(.white))
        .cornerRadius(10)
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: RecipeByType(veryPopular: false, healthScore: 100, id: 782585, title: "Cannellini Bean", readyInMinutes: 45, servings: 6, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
