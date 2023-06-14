//
//  RegisterViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 10.06.23.
//

import Foundation
import SwiftUI

final class RegistrationViewModel : ObservableObject {
//    MARK: Properties
    let firebaseManager: FirebaseProtocol = FirebaseManager()
    let customfunction: CustomFunctionProtocol = CustomFunction()
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var confirmedPassword: String = ""
    @Published var isHiddenPassword: Bool = true
    @Published var isHiddenConfirmedPassword: Bool = true
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
//    Check all fields and compare passwords
    func activateButton() -> Bool {
        if !firstName.isEmpty,
           !lastName.isEmpty,
           !emailAddress.isEmpty,
           !password.isEmpty,
           !confirmedPassword.isEmpty,
           password == confirmedPassword {
            return true
        } else {
            return false
        }
    }
    
    func registerUser() {
        isLoading = true
        customfunction.closeKeyboard()
        Task {
            do {
                try await firebaseManager.registerUser(firstName: firstName, lastName: lastName, email: emailAddress, password: password)
            } catch {
                await errorSignIn(error)
            }
        }
    }
    
    func errorSignIn(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            isLoading = false
        })
    }
}
