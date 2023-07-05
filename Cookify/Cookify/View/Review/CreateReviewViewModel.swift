//
//  ReviewViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 4.07.23.
//

import Foundation
import PhotosUI
import SwiftUI

final class CreateReviewViewModel: ObservableObject {
//    MARK: Properties
    private var firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var reviewText: String = ""
    @Published var rating: Int = 0
    @Published var imagesData: [Data] = []
    @Published var selectedImages: [Image] = [Image]()
    @Published var selectedItems: [PhotosPickerItem] = [PhotosPickerItem]()
//    View Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
//    MARK: Methods
//    Did Choise Images
    func choisedImages() async {
        await MainActor.run(body: {
            selectedImages.removeAll()
        })
        do {
            for item in selectedItems {
                guard let data = try await item.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                let image = Image(uiImage: uiImage)
                await MainActor.run(body: {
                    selectedImages.append(image)
                    imagesData.append(data)
                })
            }
        } catch {
            await errorHandling(error)
        }
    }
    
//    Send Review to Firebase
    func sendReview(recipeTitle: String, recipeId: Int) async {
        await MainActor.run {
            isLoading = true
        }
        do {
            try await firebaseManager.createReview(images: imagesData, text: reviewText, recipeTitle: recipeTitle, recipeId: recipeId, rating: rating)
            await MainActor.run(body: {
                isLoading = false
            })
        } catch {
            await errorHandling(error)
        }
    }
    
//    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
