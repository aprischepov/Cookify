//
//  File.swift
//  Cookify
//
//  Created by Artem Prishepov on 4.07.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Review: Codable {
    @DocumentID var uid: String?
    var text: String
    var recipeTitle: String
    var recipeId: Int
    var images: [String] = []
    var publishedDate: Date = Date()
    var rating: Int
    var firstName: String
    var lastName: String
    var userUID: String
    var userImage: String
}
