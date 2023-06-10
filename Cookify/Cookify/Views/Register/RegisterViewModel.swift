//
//  RegisterViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 10.06.23.
//

import Foundation
import SwiftUI

final class RegistrationViewModel : ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    @Published var isHiddenPassword = true
    @Published var isHiddenConfirmedPassword = true
    
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
}
