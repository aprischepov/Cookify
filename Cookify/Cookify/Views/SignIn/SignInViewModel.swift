//
//  SignInViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 10.06.23.
//

import Foundation

final class SignInViewModel: ObservableObject {
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var isHiddenPassword: Bool = true
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var showError: Bool = false
    
    func signIn() {
        Task {
            do {
                try await firebaseManager.signInUser(email: emailAddress, password: password)
            } catch {
                await errorSignIn(error)
            }
        }
    }
    
    func errorSignIn(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
