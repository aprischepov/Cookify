//
//  ShoppingView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShoppingView: View {
    @StateObject private var vm = ShoppingViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("It’s your shopping list")
                    .font(.jost(.medium, size: .title))
                    .padding(.horizontal, 16)
                List {
                    ForEach(vm.shoppingList, id: \.id) { recipe in
                        NavigationLink {
                            IngredientsListView(recipe: recipe)
                        } label: {
                            HStack(spacing: 8) {
                                //                                Image
                                WebImage(url: URL(string: recipe.image)).placeholder{
                                    Image("cookifyIcon")
                                        .opacity(0.3)
                                }
                                .resizable()
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                                VStack(alignment: .leading) {
                                    //                                Title
                                    Text(recipe.title)
                                        .lineLimit(1)
                                        .font(.jost(.medium, size: .body))
                                        .foregroundColor(.customColor(.black))
                                    //                                    Missing Ingredients
                                    Text("\(recipe.ingredients.count) missing ingredients")
                                        .font(.jost(.regular, size: .callout))
                                        .foregroundColor(.customColor(.gray))
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        vm.removeRecipe(indexSet: indexSet)
                    }
                }
                .listStyle(.inset)
            }
            
            .padding(.vertical, 8)
        }
    }
}

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingView()
    }
}
