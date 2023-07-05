//
//  ProfileViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 17.06.23.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
//    MARK: - Properties
//    User Properties
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
//    View Properties
    @Published var editProfile: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var showError: Bool = false
    
//    MARK: - Methods
    func signOut() {
        Task {
            do {
                try await firebaseManager.signOut()
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
    
}

enum SettingsButtons: String, CaseIterable {
    case rateTheApp = "Rate the app"
    case privacyPolice = "Privacy Police"
    
    var id: Int {
        switch self {
        case .rateTheApp:
            return 0
        case .privacyPolice:
            return 1
        }
    }
    
    var image: String {
        switch self {
        case .rateTheApp:
            return "star"
        case .privacyPolice:
            return "eye"
        }
    }
}
