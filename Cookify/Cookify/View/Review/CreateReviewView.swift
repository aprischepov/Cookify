//
//  ReviewView.swift
//  Cookify
//
//  Created by Artem Prishepov on 4.07.23.
//

import SwiftUI
import _PhotosUI_SwiftUI
import PhotosUI

struct CreateReviewView: View {
    var onReview: (Review) -> Void
    var recipe: RecipeById
    @StateObject var vm = CreateReviewViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState var showKeyboard: Bool
    var body: some View {
        VStack {
            HStack {
                //                Close Review Screen
                Button("Close") {
                    dismiss()
                }
                .font(.jost(.regular, size: .body))
                .foregroundColor(.customColor(.black))
                Spacer()
                Button {
                    //                    Send Review
                    showKeyboard = false
                    Task {
                        await vm.sendReview()
                    }
                    dismiss()
                } label: {
                    Text("Send")
                        .font(.jost(.regular, size: .body))
                        .foregroundColor(.customColor(.white))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background {
                            Color.customColor(.orange)
                                .cornerRadius(10)
                        }
                }
                .disabled(vm.reviewText == "")
                .opacity(vm.reviewText == "" ? 0.7 : 1)
            }
            .padding(.horizontal, 16)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    //                    Recipe Title
                    HStack(alignment: .center, spacing: 8) {
                        Text("Recipe title:")
                            .font(.jost(.bold, size: .body))
                        Text(recipe.title)
                            .font(.jost(.regular, size: .body))
                    }
                    .padding(.horizontal, 16)
                    //                    Review Text
                    TextField("Writing review", text: $vm.reviewText, axis: .vertical)
                        .padding(8)
                        .frame(minHeight: 180, alignment: .top)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).stroke()
                                .foregroundColor(.customColor(.orange))
                        }
                        .focused($showKeyboard)
                        .padding(.horizontal, 16)
                    //                    Images
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(0..<vm.selectedImages.count, id: \.self) { index in
                                vm.selectedImages[index]
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .scaledToFit()
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            Divider()
            HStack {
                PhotosPicker(selection: $vm.selectedItems) {
                    Image("galeryIcon")
                }
                .onChange(of: vm.selectedItems) { _ in
                    Task {
                        await vm.choisedImages()
                    }
                }
                Spacer()
                Button("Done") {
                    showKeyboard = false
                }
                .opacity(showKeyboard ? 1 : 0)
            }
            .foregroundColor(.customColor(.black))
            .font(.jost(.regular, size: .body))
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical, 8)
        .overlay {
            LoadingView(show: $vm.isLoading)
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        CreateReviewView(onReview: { _ in
            
        }, recipe: RecipeById(id: 1, title: "Vegetarian Grilling", image: "", readyInMinutes: 34, healthScore: 100, servings: 6, summary: "", analyzedInstructions: [], extendedIngredients: [], nutrition: Nutrition(nutrients: [])))
    }
}
