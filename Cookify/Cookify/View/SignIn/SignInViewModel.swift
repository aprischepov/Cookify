//
//  SignInViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 10.06.23.
//

import Foundation
import SwiftUI

final class SignInViewModel: ObservableObject {
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    let customfunction: CustomFunctionProtocol = CustomFunction()
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var isHiddenPassword: Bool = true
    @Published var showError: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var isLoading: Bool = false
    
    func signIn() {
        isLoading = true
        customfunction.closeKeyboard()
        Task {
            do {
                try await firebaseManager.signInUser(email: emailAddress, password: password)
                try await firebaseManager.fetchUser()
            } catch {
                await errorSignIn(error)
            }
        }
    }
    
    private func errorSignIn(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            isLoading = false
        })
    }
    
    func signInGoogle() {
        isLoading = true
        Task {
            do {
                try await firebaseManager.signInWithGoogle()
            } catch {
                await errorSignIn(error)
            }
        }
    }
}
