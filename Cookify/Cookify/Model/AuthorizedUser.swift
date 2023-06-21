//
//  AuthorizedUser.swift
//  Cookify
//
//  Created by Artem Prishepov on 20.06.23.
//

import Foundation

final class AuthorizedUser: ObservableObject {
    static let shared = AuthorizedUser()
    var firstName: String?
    var lastName: String?
    var emailAddress: String?
    var imageUrl: URL?
    
    private init() {}
    
    func deleteUserData() {
        firstName = nil
        lastName = nil
        emailAddress = nil
        imageUrl = nil
    }
}
