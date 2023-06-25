//
//  RecipeCard.swift
//  Cookify
//
//  Created by Artem Prishepov on 16.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    @State var isFavorite: Bool
    var favoriteTapped: (Bool) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Main Recipe Image - Upper Half of Card
                WebImage(url: URL(string: recipe.image)).placeholder {
                    Image("cookifyIcon")
                        .opacity(0.3)
                }
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 240)
                    .clipped()
                    .overlay {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("\(recipe.readyInMinutes.description) min")
                        }
                        .font(.jost(.medium, size: .body))
                        .foregroundColor(.customColor(.white))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.customColor(.black).opacity(0.5))
                        .roundedCorner(10, corners: .bottomRight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
//            Stack bottom half of card
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.jost(.bold, size: .title))
                HStack(alignment: .center, spacing: 8) {
                    Text("Health Score:")
                        .font(.jost(.semiBold, size: .body))
                    Text("\(recipe.healthScore)%")
                        .foregroundColor(.customColor(.darkGray))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.customColor(.lightOrange))
                        .cornerRadius(8)
                }
                .font(.jost(.semiBold, size: .body))
                Divider()
                    .padding(.top, 4)
                HStack(spacing: 8) {
                    Text("$ \(recipe.pricePerServing, specifier: "%.2f")")
                        .font(.jost(.semiBold, size: .titleThree))
                    Text("for \(recipe.servings) people")
                        .font(.jost(.regular, size: .body))
                        .foregroundColor(.customColor(.darkGray))
                    Spacer()
                    Button {
                        favoriteTapped(isFavorite)
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 30, height: 24)
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Recipe(isFavorite: false, veryPopular: false, healthScore: 100, id: 782585, title: "Cannellini Bean", readyInMinutes: 45, servings: 6, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg", pricePerServing: 10.0), isFavorite: false, favoriteTapped: { _ in })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
