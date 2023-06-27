//
//  EditProfileViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 18.06.23.
//

import Foundation
import SwiftUI
import Combine

final class EditProfileViewModel: ObservableObject {
//    MARK: - Properties
    private let firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published private var authorizedUser = AuthorizedUser.shared
    private var subscriptions = Set<AnyCancellable>()
//    View Properies
    @Published var inputUserFirstName: String = ""
    @Published var inputUserLastName: String = ""
    @Published var inputUserEmail: String = ""
    @Published var userImage: String = ""
    @Published var showImagePicker: Bool = false
    @Published var isActivedButton: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError = true
        }
    }
    @Published var showError: Bool = false
    
    init() {
        inputUserFirstName = authorizedUser.firstName ?? ""
        inputUserLastName = authorizedUser.lastName ?? ""
        inputUserEmail = authorizedUser.emailAddress ?? ""
        userImage = authorizedUser.imageUrl?.description ?? ""
        
        Publishers.CombineLatest4($inputUserFirstName, $inputUserLastName, $inputUserEmail, $userImage).sink { [weak self] _ in
            guard let self else { return }
            self.checkChanges()
        }.store(in: &subscriptions)
    }
    
//    MARK: - Methods
//    Button Activation
    func checkChanges() {
        isActivedButton = inputUserFirstName != authorizedUser.firstName ?? "" ||
        inputUserLastName != authorizedUser.lastName ?? "" ||
        inputUserEmail != authorizedUser.emailAddress ?? "" ||
        userImage != authorizedUser.imageUrl?.description ?? ""
    }
    
//    Update Data in Firebase Storage
    func updateData() {
        guard let imageUrl = URL(string: userImage) else { return }
        Task {
            do {
                try await firebaseManager.updateUserProfile(firstName: inputUserFirstName, lastName: inputUserLastName, email: inputUserEmail, imageUrl: imageUrl)
            } catch {
                await errorHandling(error)
            }
        }
    }
    
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
    
//    MARK: Deinit
    deinit {
        subscriptions.removeAll()
    }
}
