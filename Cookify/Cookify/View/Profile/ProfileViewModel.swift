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
    @AppStorage("userFirstName") var userFirsNameStored: String?
    @AppStorage("userLastName") var userLastNameStored: String?
    @AppStorage("userEmail") var userEmailStored: String?
    @AppStorage("userImage") var userImage: String?
    @Published var userProfile: User?
    @Published var editProfile: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var showError: Bool = false
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    
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
