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
    var images: [String] = []
//    var imageReferenceId: String = ""
    var publishedDate: Date = Date()
    var likedIds: [String] = []
    var firstName: String
    var lastName: String
    var userUID: String
}
