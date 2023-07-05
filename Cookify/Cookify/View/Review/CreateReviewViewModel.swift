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
    @Published var imageData: Data?
//    View Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    @Published var selectedImages: [Image] = [Image]()
    @Published var selectedItems: [PhotosPickerItem] = [PhotosPickerItem]()
    
//    MARK: Methods
//    Choise Image
//    func uploadImage(image: PhotosPickerItem?) async {
//        guard let image = image else { return }
//        do {
//            if let newImageData = try await image.loadTransferable(type: Data.self),
//               let image = UIImage(data: newImageData),
//               let compressedImageData = image.jpegData(compressionQuality: 0.7) {
//                await MainActor.run(body: {
//                    imageData = compressedImageData
//                })
//            }
//        } catch {
//            await errorHandling(error)
//        }
//    }
    
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
                })
            }
        } catch {
            await errorHandling(error)
        }
    }
    
//    Send Review to Firebase
    func sendReview() async {
        isLoading = true
        do {
            try await firebaseManager.createReview(imageData: imageData, text: reviewText)
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
