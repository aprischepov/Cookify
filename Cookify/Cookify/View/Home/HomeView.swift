//
//  HomeView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        //                Random Recipe and Profile
                        HStack(alignment: .center) {
                            Button {
                                vm.showRandomRecipe.toggle()
                            } label: {
                                Image("random")
                            }
                            .fullScreenCover(isPresented: $vm.showRandomRecipe) {
                                RandomRecipeView()
                            }
                            Spacer()
                            NavigationLink {
                                //                    profile screen
                                ProfileView()
                            } label: {
                                WebImage(url: vm.user.imageUrl).placeholder {
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
                            Text("Hey \(vm.user.firstName ?? "") 👋")
                                .font(.jost(.semiBold, size: .title))
                            Text("What are you cooking today")
                                .font(.jost(.medium, size: .titleThree))
                        }
                    }
                    .padding(.horizontal, 16)
                    //                                    Search Recipes
                    Button {
                        vm.showSearch.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 48)
                                .foregroundColor(.customColor(.lightGray))
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                Text("Search Recipes")
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
                                    vm.sendAction(actionType: .changedTypeGetNewRecipes(type: type))
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
                        ForEach(vm.fullListRecipes, id: \.id) { recipe in
                            NavigationLink {
                                RecipeView(id: recipe.id)
                            } label: {
                                RecipeCard(recipe: recipe) {
                                    vm.sendAction(actionType: .changeFromFavoritesRecipes(recipe: recipe))
                                }
                            }
                        }
                        Button {
                            vm.sendAction(actionType: .getRecipes(type: vm.currentTypeRecipes))
                        } label: {
                            CustomButton(title: "Load more", style: .borderButton)
                        }
                        .opacity(vm.dataCondition == .loading ? 0 : 1)
                        ProgressView()
                            .opacity(vm.dataCondition == .loading ? 1 : 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.customColor(.background))
            .padding(.vertical, 8)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: HomeViewModel(subject: PassthroughSubject<ActionsWithRecipes, Never>(), user: AuthorizedUser.shared))
    }
}
