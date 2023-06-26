//
//  AuthorizedUser.swift
//  Cookify
//
//  Created by Artem Prishepov on 20.06.23.
//

import Foundation

final class AuthorizedUser: ObservableObject {
    static let shared = AuthorizedUser()
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var emailAddress: String?
    @Published var imageUrl: URL?
    
    private init() {}
    
    func deleteUserData() {
        firstName = nil
        lastName = nil
        emailAddress = nil
        imageUrl = nil
    }
}
