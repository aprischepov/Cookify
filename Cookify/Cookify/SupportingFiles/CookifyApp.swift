//
//  CookifyApp.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI
import UIKit
import Firebase

@main
struct CookifyApp: App {
    @AppStorage("appCondition") var appCondition: AppCondition?
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var preloadManager = PreloadScreenManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            switch appCondition {
            case .onboarding:
                OnboardingView()
            case .signIn:
                ZStack {
                    MainView()
                    if preloadManager.state != .completed {
                        PreloadView()
                    }
                }
                .environmentObject(preloadManager)
            case .signOut:
                SignInView()
            case .none:
                OnboardingView()
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
