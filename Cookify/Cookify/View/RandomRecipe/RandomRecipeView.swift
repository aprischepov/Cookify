//
//  RandomRecipeView.swift
//  Cookify
//
//  Created by Artem Prishepov on 28.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RandomRecipeView: View {
    @StateObject private var vm: RandomRecipeViewModel = RandomRecipeViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                List {
                    ForEach(vm.randomRecipesList, id: \.id) { recipe in
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
                }
                .listStyle(.inset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct RandomRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RandomRecipeView()
    }
}
