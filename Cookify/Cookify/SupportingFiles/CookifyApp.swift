//
//  CookifyApp.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI
import UIKit

@main
struct CookifyApp: App {
    @AppStorage("appCondition") var appCondition: AppCondition?
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Jost-Medium", size: 18) ?? .systemFont(ofSize: 18)]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -10000, vertical: 0), for: .default)
        return true
    }
}
