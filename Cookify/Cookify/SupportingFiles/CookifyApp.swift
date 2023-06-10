//
//  CookifyApp.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI

@main
struct CookifyApp: App {
    @AppStorage("appCondition") var appCondition: AppCondition?
    var body: some Scene {
        WindowGroup {
            switch appCondition {
            case .onboarding:
                ContentView()
            case .signIn:
                MainView()
            case .signOut:
                SignInView()
            case .none:
                ContentView()
            }
        }
    }
}
