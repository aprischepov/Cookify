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
//                        like
                    } label: {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Button {
//                        mark
                    } label: {
                        Image(systemName: "bookmark")
                            .resizable()
                            .frame(width: 20, height: 24)
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
//        ZStack {
//            HStack(alignment: .center, spacing: 8) {
////                Recipe's Image
//                WebImage(url: URL(string: recipe.image)).placeholder {
//                    Image(systemName: "photo")
//                        .foregroundColor(.customColor(.gray))
//                    }
//                    .resizable()
//                    .frame(width: 112, height: 112)
//                    .aspectRatio(contentMode: .fill)
//                    .cornerRadius(10)
////                Recipe's Information
//                VStack(alignment: .leading, spacing: 4) {
////                    Title
//                    Text(recipe.title)
//                        .font(.jost(.regular, size: .footnote))
////                    Health Score
//                    HStack(alignment: .center, spacing: 4) {
//                        Text("Health score:")
//                            .foregroundColor(.customColor(.orange))
//                        Text("\(recipe.healthScore) %")
//                            .foregroundColor(.customColor(.gray))
//                    }
//                    .font(.jost(.regular, size: .caption))
////                    Ready In Minutes
//                    HStack(alignment: .center, spacing: 4) {
//                        Image(systemName: "clock")
//                            .foregroundColor(.customColor(.orange))
//                        Text("\(recipe.readyInMinutes) min")
//                            .font(.jost(.regular, size: .caption))
//                            .foregroundColor(.customColor(.gray))
//                    }
////                    Count Servings
//                    HStack(alignment: .center, spacing: 4) {
//                        Image(systemName: "person.2")
//                            .foregroundColor(.customColor(.orange))
//                        Text("\(recipe.servings) people")
//                            .font(.jost(.regular, size: .caption))
//                            .foregroundColor(.customColor(.gray))
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//            }
//            .padding(16)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .frame(maxWidth: .infinity, maxHeight: 144)
//        .background(Color.customColor(.white))
//        .cornerRadius(10)
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: RecipeByType(veryPopular: false, healthScore: 100, id: 782585, title: "Cannellini Bean", readyInMinutes: 45, servings: 6, image: "https://spoonacular.com/recipeImages/782585-312x231.jpg", pricePerServing: 10.0))
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
