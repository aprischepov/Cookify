//
//  ImagePicker.swift
//  Cookify
//
//  Created by Artem Prishepov on 19.06.23.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageUrl: String
    @Environment(\.dismiss) var dismiss
    let sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
           let imagePicker = UIImagePickerController()
           imagePicker.allowsEditing = false
           imagePicker.sourceType = sourceType
           imagePicker.delegate = context.coordinator
           return imagePicker
       }

       func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

       final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
           private var uid = UserDefaults.standard.string(forKey: "uid")
           private var parent: ImagePicker

           init(_ parent: ImagePicker) {
               self.parent = parent
           }

           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

               var selectedImage = UIImage()

               if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   selectedImage = image
               }

               if picker.sourceType == UIImagePickerController.SourceType.camera {

                   let imageName = "photo.jpeg"
                   let documentDirectory = NSTemporaryDirectory()
                   let localPath = documentDirectory.appending(imageName)

                   if let data = selectedImage.jpegData(compressionQuality: 0.8) {
                       do {
                           try data.write(to: URL(fileURLWithPath: localPath))
                       } catch {
                           print(error)
                       }
                   }
                   parent.imageUrl = URL(fileURLWithPath: localPath).absoluteString
               } else if let selectedImageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                   parent.imageUrl = selectedImageUrl.absoluteString
               }

               parent.dismiss()
           }
       }

       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

   }
