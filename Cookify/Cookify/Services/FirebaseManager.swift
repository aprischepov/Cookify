//
//  FirebaseManager.swift
//  Cookify
//
//  Created by Artem Prishepov on 11.06.23.
//

import Foundation
import SwiftUI
import Firebase

protocol FirebaseProtocol {
    func signInUser(email: String, password: String) async throws
}

final class FirebaseManager: FirebaseProtocol {
//    MARK: - Sign In method
    func signInUser(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
}

enum Errors: Error {
    case errorAuthorization
    
    var description: String {
        switch self {
        case .errorAuthorization:
            return "Error with authorization"
        }
    }
}
