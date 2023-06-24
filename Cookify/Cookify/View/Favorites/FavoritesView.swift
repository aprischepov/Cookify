//
//  FavoritesView.swift
//  Cookify
//
//  Created by Artem Prishepov on 21.06.23.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var vm: FavoritesViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Favorites")
                .font(.jost(.semiBold, size: .title))
                .padding(.horizontal, 16)
            List {
                ForEach(vm.listFavoritesRecipes, id: \.id) { recipe in
                    FavoriteRecipeCard(recipe: recipe)
                }
                .onDelete { indexSet in
                    vm.sendIndexRecipes(index: indexSet)
                    vm.listFavoritesRecipes.remove(atOffsets: indexSet)
//                    for index in indexSet {
//                        vm.removeRecipe(index: index)
//                    }
//                    for index in indexSet {
////                        vm.removeRecipe(index: index)
//                        vm.likedRecipes.remove(at: index)
//                    }
                    
//                    vm.removeRecipe(index: index)
//                    let rem = vm.likedRecipes.remove(atOffsets: index)
                }
            }
            .listStyle(.inset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical, 8)
//        .task {
//            await vm.fetchRecipes()
//        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(vm: FavoritesViewModel())
    }
}
