//
//  FavoritesView.swift
//  Cookify
//
//  Created by Artem Prishepov on 21.06.23.
//

import SwiftUI
import Combine

struct FavoritesView: View {
    @StateObject var vm: FavoritesViewModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Favorites")
                    .font(.jost(.semiBold, size: .title))
                    .padding(.horizontal, 16)
                List {
                    ForEach(vm.favoriteRecipes, id: \.id) { recipe in
                        ZStack(alignment: .top) {
                            NavigationLink {
                                RecipeView(id: recipe.id)
                            } label: {
                                FavoriteRecipeCard(recipe: recipe)
                            }
                            .opacity(0)
                            FavoriteRecipeCard(recipe: recipe)
                        }
                    }
                    .onDelete { indexSet in
                        vm.removeFavriteRecipe(indexSet: indexSet)
                    }
                }
                .listStyle(.inset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 8)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(vm: FavoritesViewModel(subject: PassthroughSubject<ActionsWithRecipes, Never>()))
    }
}
