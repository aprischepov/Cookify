//
//  HomeView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        //                Random Recipe and Profile
                        HStack(alignment: .center) {
                            Button {
                                //                    get random recipe
                            } label: {
                                Image("random")
                            }
                            Spacer()
                                NavigationLink {
                                    //                    profile screen
                                    ProfileView()
                                } label: {
                                WebImage(url: vm.userProfile?.image).placeholder {
                                    Image("avatar")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                            }
                        }
                        //                Title
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Hey \(vm.userProfile?.firstName ?? "") 👋")
                                .font(.jost(.semiBold, size: .title))
                            Text("What are you cooking today")
                                .font(.jost(.medium, size: .titleThree))
                        }
                    }
                    .padding(.horizontal, 16)
                    //                                    Search Recipes
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 56)
                            .foregroundColor(.customColor(.lightGray))
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "magnifyingglass")
                            TextField("Search", text: $vm.searchText)
                                .font(.jost(.regular, size: .body))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                    }
                    .padding(.horizontal, 16)
                    //                Recipes Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 16) {
                            ForEach(RecipeType.allCases, id: \.id) { type in
                                Button {
                                    vm.listRecipes.removeAll()
                                    vm.isLoadingNewData = true
                                    vm.currentTypeRecipes = type
                                    Task {
                                        await vm.getRecipesByType()
                                    }
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
                    VStack(alignment: .center, spacing: 8) {
                        ForEach(vm.listRecipes, id: \.id) { recipe in
                            RecipeCard(recipe: recipe)
                        }
                        Button {
                            Task {
                                await vm.getRecipesByType()
                            }
                        } label: {
                            CustomButton(title: "Load more", style: .borderButton)
                        }
                    }
                    .padding(.horizontal, 16)
                    .opacity(vm.isLoadingNewData ? 0 : 1)
                    .overlay {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.customColor(.background))
            .padding(.vertical, 8)
            .task {
                if vm.userProfile != nil { return }
                vm.isLoadingNewData = true
                await vm.fetchUserData()
                await vm.getRecipesByType()
            }
//            .refreshable {
//                //            refresh action
//                vm.userProfile = nil
//                await vm.fetchUserData()
//        }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
