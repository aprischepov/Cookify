//
//  EditProfileViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 18.06.23.
//

import Foundation
import SwiftUI
import PhotosUI

final class EditProfileViewModel: ObservableObject {
//    MARK: - Properties
//    User Properties
    @AppStorage("userFirstName") var userFirsNameStored: String?
    @AppStorage("userLastName") var userLastNameStored: String?
    @AppStorage("userEmail") var userEmailStored: String?
    @AppStorage("userImage") var userImageStored: String?
//    View Properies
    @Published var inputUserFirstName: String = ""
    @Published var inputUserLastName: String = ""
    @Published var inputUserEmail: String = ""
    @Published var userImage: String = ""
    @Published var showImagePicker: Bool = false
    @Published var imageItem: PhotosPickerItem?
    
    init() {
        inputUserFirstName = userFirsNameStored ?? ""
        inputUserLastName = userLastNameStored ?? ""
        inputUserEmail = userEmailStored ?? ""
        userImage = userImageStored ?? ""
    }
    
//    MARK: - Methods
//    Button Activation
    func checkChanges() -> Bool{
        //    If something ghanges - button is active
        if inputUserFirstName == userFirsNameStored,
           inputUserLastName == userLastNameStored,
           inputUserEmail == userEmailStored {
            return false
        } else {
            return true
        }
    }
    
//    Update Local Image
    func updateImage(image: PhotosPickerItem) {
        Task {
            do {
                guard let imageData = try await image.loadTransferable(type: Data.self) else { return }
                
                await MainActor.run(body: {
//                    userImage = imageData.absoluteString
                })
            }
        }
    }
    
//    Update Data in Firebase Storage
    func updateData() {
        
    }
}
