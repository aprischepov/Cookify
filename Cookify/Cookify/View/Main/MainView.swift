//
//  MainView.swift
//  Cookify
//
//  Created by Artem Prishepov on 9.06.23.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    @EnvironmentObject var preloadManager: PreloadScreenManager
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                preloadManager.dismiss()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PreloadScreenManager())
    }
}
