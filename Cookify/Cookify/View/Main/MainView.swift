//
//  MainView.swift
//  Cookify
//
//  Created by Artem Prishepov on 9.06.23.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    var body: some View {
        TabView {
            HomeView(vm: vm.homeViewModel)
                .tabItem {
                    Image("homeIcon")
                }
            CommunityView()
                .tabItem {
                    Image("reviewIcon")
                }
            SearchByIngredientsView()
                .tabItem {
                    Image("searchIcon")
                }
            ShoppingView()
                .tabItem {
                    Image("bagIcon")
                }
            FavoritesView(vm: vm.favoritesViewModel)
                .tabItem {
                    Image("favoritesIcon")
                }
        }
        .task {
            await vm.getAllData()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
