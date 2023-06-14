//
//  MainView.swift
//  Cookify
//
//  Created by Artem Prishepov on 9.06.23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ShoppingView()
                .tabItem {
                    Label("Shopping", systemImage: "list.bullet")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
