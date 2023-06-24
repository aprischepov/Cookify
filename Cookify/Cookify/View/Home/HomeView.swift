//
//  HomeView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    @StateObject private var user = AuthorizedUser.shared
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        //                Random Recipe and Profile
                        HStack(alignment: .center) {
                            Button {
                                vm.showSearch.toggle()
                            } label: {
                                Image("random")
                            }
                            Spacer()
                            NavigationLink {
                                //                    profile screen
                                ProfileView()
                            } label: {
                                WebImage(url: vm.authorizedUser.imageUrl).placeholder {
                                    Image("avatar")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(Color.customColor(.orange))
                                }
                            }
                        }
                        //                Title
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Hey \(user.firstName ?? "") 👋")
                                .font(.jost(.semiBold, size: .title))
                            Text("What are you cooking today")
                                .font(.jost(.medium, size: .titleThree))
                        }
                    }
                    .padding(.horizontal, 16)
                    //                                    Search Recipes
                    Button {
                        //                        action search bar
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 48)
                                .foregroundColor(.customColor(.lightGray))
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                                    .font(.jost(.regular, size: .body))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.customColor(.gray))
                        }
                    }
                    .padding(.horizontal, 16)
                    .fullScreenCover(isPresented: $vm.showSearch) {
                        SearchRecipesView()
                    }
                    
                    //                Recipes Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 16) {
                            ForEach(RecipeType.allCases, id: \.id) { type in
                                Button {
                                    vm.getMoreRecipesButtonAction(type: type)
                                } label: {
                                    Text(type.rawValue.capitalizingFirstLetter())
                                        .font(.jost(.regular, size: .body))
                                        .foregroundColor(vm.currentTypeRecipes == type ? .customColor(.white) : .customColor(.black))
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(vm.currentTypeRecipes == type ? .customColor(.orange) : .customColor(.lightGray))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(maxWidth: .infinity)
                    //                Recipes
                    VStack(alignment: .center, spacing: 16) {
                        switch vm.dataCondition {
                        case .loading:
                            Spacer()
                            ProgressView()
                            Spacer()
                        case .loaded:
                            ForEach(vm.listRecipes, id: \.id) { recipe in
                                RecipeCard(recipe: recipe,
                                           isFavorite: vm.searchById(id: recipe.id)) { isFavorite in
                                    if isFavorite {
                                        vm.removeFromFavorites(recipe: FavoriteRecipe(veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing))
//                                        vm.removeFromFavorites(recipe: FavoriteRecipe(veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing))
//                                        let selectedRecipe = vm.listFavoritesRecipes.filter{ $0.id == recipe.id }
                                        
//                                        let selectedRecipe = vm.listFavoritesRecipes.first{ $0.id == recipe.id }
                                        
//                                        vm.listFavoritesRecipes.removeAll { favoriteRecipe in
//                                            favoriteRecipe.id == recipe.id
//                                        }
                                    } else {
                                        vm.addRecipeToFavorites(recipe: FavoriteRecipe(veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing))
//                                        vm.listFavoritesRecipes.append(FavoriteRecipe(veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing))
//                                        vm.addRecipeToFavorites(recipe: FavoriteRecipe(veryPopular: recipe.veryPopular, healthScore: recipe.healthScore, id: recipe.id, title: recipe.title, readyInMinutes: recipe.readyInMinutes, servings: recipe.servings, image: recipe.image, pricePerServing: recipe.pricePerServing))
                                    }
                                }
                            }
                            Button {
                                Task {
                                    await vm.getRecipesByType()
                                }
                            } label: {
                                CustomButton(title: "Load more", style: .borderButton)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.customColor(.background))
            .padding(.vertical, 8)
            .task {
                await vm.getAllDataWithStartApp()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: HomeViewModel())
    }
}
