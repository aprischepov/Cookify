//
//  User.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var emailAddress: String
    var image: URL
}
