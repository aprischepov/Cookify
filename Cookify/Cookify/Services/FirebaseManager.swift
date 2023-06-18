//
//  FirebaseManager.swift
//  Cookify
//
//  Created by Artem Prishepov on 11.06.23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

protocol FirebaseProtocol {
    func signInUser(email: String, password: String) async throws
    func registerUser(firstName: String, lastName: String, email: String, password: String) async throws
//    func upgradeUserData(firstName: String, lastName: String, email: String, image: String) async throws
    func fetchUser() async throws -> User?
    func signInWithGoogle() async throws
    func logGoogleUser(user: GIDGoogleUser) async throws
    func signOut() async throws
}

final class FirebaseManager: FirebaseProtocol {
    //    MARK: - Properties
    @AppStorage("appCondition") var appConditionStored: AppCondition?
    @AppStorage("userFirstName") var userFirsNameStored: String = ""
    @AppStorage("userLastName") var userLastNameStored: String = ""
    @AppStorage("userEmail") var userEmailStored: String = ""
    @AppStorage("userImage") var userImage: String = ""
    @AppStorage("userUID") var userUID: String = ""
    //    @AppStorage("user") var userLocal: UserLocal
    
    //    MARK: - Methods
    //    Sign In
    func signInUser(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    //    Register New User
    func registerUser(firstName: String, lastName: String, email: String, password: String) async throws {
        //        Creating Firebase Account
        try await Auth.auth().createUser(withEmail: email, password: password)
        //        Uploading Photo Into Firebase Storage
        guard let userUID = Auth.auth().currentUser?.uid,
              let avatar = UIImage(named: "avatar"),
              let imageData = avatar.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("ProfileImages").child(userUID)
        let _ = try await storageRef.putDataAsync(imageData)
        //        Creating Downloading URL
        let downloadURL = try await storageRef.downloadURL()
        //        Creating User Object
        let user = User(firstName: firstName, lastName: lastName, emailAddress: email, image: downloadURL)
        //        Saving User Object
        let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user) { [weak self] error in
            guard let self,
                  error == nil else { return }
            self.appConditionStored = .signIn
            self.userFirsNameStored = firstName
            self.userLastNameStored = lastName
            self.userEmailStored = email
            self.userImage = downloadURL.description
        }
    }
    
    //    Fetch User
    func fetchUser() async throws -> User? {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        let user = try await Firestore.firestore().collection("Users").document(userId).getDocument(as: User.self)
        
        await MainActor.run(body: {
            appConditionStored = .signIn
            userFirsNameStored = user.firstName
            userLastNameStored = user.lastName
            userEmailStored = user.emailAddress
            userImage = user.image.description
        })
        return user
    }
    
    //    Sign In With Google
    func signInWithGoogle() async throws {
        if let clientId = FirebaseApp.app()?.options.clientID {
            let configuration = GIDConfiguration(clientID: clientId)
            GIDSignIn.sharedInstance.configuration = configuration
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootController())
            let user = userAuth.user
            guard let idToken = user.idToken else { return }
            let accesToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accesToken.tokenString)
            try await Auth.auth().signIn(with: credential)
            await MainActor.run(body: {
                appConditionStored = .signIn
                userFirsNameStored = user.profile?.familyName ?? ""
                userLastNameStored = user.profile?.familyName ?? ""
                userEmailStored = user.profile?.email ?? ""
                userImage = user.profile?.imageURL(withDimension: 100)?.description ?? ""
            })
        }
    }
    
    //    Logging Google User
    func logGoogleUser(user: GIDGoogleUser) async throws {
        guard let idToken = user.idToken else { return }
        let accesToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accesToken.tokenString)
        
        try await Auth.auth().signIn(with: credential)
        
    }
    //    Sign Out
    func signOut() async throws {
        try Auth.auth().signOut()
        await MainActor.run(body: {
            appConditionStored = .signOut
            userFirsNameStored = ""
            userLastNameStored = ""
            userEmailStored = ""
            userImage = ""
        })
    }
}

//enum Errors: Error {
//    case errorAuthorization
//
//    var description: String {
//        switch self {
//        case .errorAuthorization:
//            return "Error with authorization"
//        }
//    }
//}
