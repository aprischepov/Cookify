//
//  CookifyApp.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI

@main
struct CookifyApp: App {
    @AppStorage("shouldOnboardingHidden") var shouldOnboardingHidden: Bool?
    var body: some Scene {
        WindowGroup {
            if shouldOnboardingHidden ?? false {
                SignInView()
            } else {
                ContentView()
            }
        }
    }
}
