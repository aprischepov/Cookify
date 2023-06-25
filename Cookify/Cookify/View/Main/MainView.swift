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
            HomeView(vm: vm.homeViewModel, user: vm.user)
                .tabItem {
                    Image(systemName: "house")
                }
            CommunityView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            ShoppingView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
            FavoritesView(vm: vm.favoritesViewModel)
                .tabItem {
                    Image(systemName: "heart")
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
