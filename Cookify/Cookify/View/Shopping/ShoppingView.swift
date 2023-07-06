//
//  ShoppingView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct ShoppingView: View {
    @StateObject var vm: ShoppingViewModel = ShoppingViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Shopping list")
                    .font(.jost(.semiBold, size: .largeTitle))
                    .padding(.horizontal, 16)
                if vm.shoppingList.isEmpty {
                    EmptyListView(type: .emptyShoppingList)
                } else {
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
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                                    VStack(alignment: .leading) {
                                        //                                Title
                                        Text(recipe.title)
                                            .lineLimit(2)
                                            .font(.jost(.medium, size: .body))
                                            .foregroundColor(.customColor(.black))
                                        //                                    Missing Ingredients
                                        Text("\(recipe.ingredientsCount) missing ingredients")
                                            .font(.jost(.regular, size: .callout))
                                            .foregroundColor(.customColor(.gray))
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            vm.removeFromShoppingList(indexSet: indexSet)
                        }
                    }
                    .listStyle(.inset)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 8)
        }
        .alert(vm.errorMessage, isPresented: $vm.showError) {}
        .task {
            await vm.fetchShoppingList()
        }
    }
}

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingView()
    }
}
