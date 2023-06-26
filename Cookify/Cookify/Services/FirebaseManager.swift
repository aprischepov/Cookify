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
    func updateUserProfile(firstName: String, lastName: String, email: String, imageUrl: URL) async throws
    func fetchUser() async throws
    func signInWithGoogle() async throws
    func logGoogleUser(user: GIDGoogleUser) async throws
    func signOut() async throws
    func addToFavorites(recipe: Recipe) async throws -> String
    func fetchFavoritesRecipes() async throws -> [Recipe]
    func deleteFromFavorites(recipe: Recipe) async throws
}

final class FirebaseManager: FirebaseProtocol {
    //    MARK: - Properties
    @AppStorage("appCondition") var appConditionStored: AppCondition?
    private let authorizedUser = AuthorizedUser.shared
    
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
//            Вопрос к самому себе: нужны ли вообще на этом этапе закидывать в синглтон, все равно же дальше фетчу на главной
            self.authorizedUser.firstName = firstName
            self.authorizedUser.lastName = lastName
            self.authorizedUser.imageUrl = downloadURL
            self.authorizedUser.emailAddress = email
        }
    }
    
    func updateUserProfile(firstName: String, lastName: String, email: String, imageUrl: URL) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let imageData = try Data(contentsOf: imageUrl)
        guard let imageData = UIImage(data: imageData)?.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("ProfileImages").child(userId)
        let _ = try await storageRef.putDataAsync(imageData)
        let downloadURL = try await storageRef.downloadURL()
        let updatedUser = User(firstName: firstName, lastName: lastName, emailAddress: email, image: downloadURL)
        try Firestore.firestore().collection("Users").document(userId).setData(from: updatedUser)
        await MainActor.run(body: {
        authorizedUser.firstName = firstName
        authorizedUser.lastName = lastName
        authorizedUser.emailAddress = email
        authorizedUser.imageUrl = imageUrl
        })
    }
    
    //    Fetch User
    func fetchUser() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let user = try await Firestore.firestore().collection("Users").document(userId).getDocument(as: User.self)
        
        await MainActor.run(body: {
            appConditionStored = .signIn
            authorizedUser.firstName = user.firstName
            authorizedUser.lastName = user.lastName
            authorizedUser.imageUrl = user.image
            authorizedUser.emailAddress = user.emailAddress
        })
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
                authorizedUser.firstName = user.profile?.name
                authorizedUser.lastName = user.profile?.familyName
                authorizedUser.imageUrl = user.profile?.imageURL(withDimension: 100)
                authorizedUser.emailAddress = user.profile?.email
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
            AuthorizedUser.shared.deleteUserData()
        })
    }
    //  Add to Favorites Recipes
    func addToFavorites(recipe: Recipe) async throws -> String {
        guard let userId = Auth.auth().currentUser?.uid else { return "" }
            let recipeDoc = try Firestore.firestore().collection("Users").document(userId).collection("Liked").addDocument(from: recipe)
        return recipeDoc.documentID
    }
    //  Load Favorites Recipes
    func fetchFavoritesRecipes() async throws -> [Recipe] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }
        return  try await Firestore.firestore().collection("Users").document(userId).collection("Liked").getDocuments().documents.compactMap({ recipe -> Recipe? in
            try recipe.data(as: Recipe.self)
        })
    }
//    Delete Favorites Recipes
    func deleteFromFavorites(recipe: Recipe) async throws {
        guard let userId = Auth.auth().currentUser?.uid,
              let recipeUid = recipe.uid else { return }
        try await Firestore.firestore().collection("Users").document(userId).collection("Liked").document(recipeUid).delete()
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

enum Actions {
    case upload
    case remove
}
