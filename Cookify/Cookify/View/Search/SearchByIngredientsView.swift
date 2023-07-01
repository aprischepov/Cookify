//
//  SearchView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI

struct SearchByIngredientsView: View {
    @StateObject private var vm = SearchByIngredientsViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Which ingredients are available?")
                        .font(.jost(.semiBold, size: .title))
                        .foregroundColor(.customColor(.black))
                    VStack {
                        ForEach($vm.textfieldModels, id: \.id) { $textfiedld in
                            IngredientTextfield(text: $textfiedld.text)
                        }
                    }
                    .font(.jost(.regular, size: .callout))
                    Button("Add ingredient") {
                        Task {
                            await vm.addTextfield()
                        }
                    }
                    .font(.jost(.medium, size: .callout))
                    .opacity(vm.textfieldModels.count == 3 ? 0 : 1)
                    Button {
                        Task {
                            await vm.findRecipesButtonAction()
                        }
                    } label: {
                        CustomButton(title: "Find recipes",
                                     style: .filledButton)
                    }
                    .opacity(vm.isButtonActivated ? 1 : 0.7)
                    .disabled(!vm.isButtonActivated)
                    
                    //            Recipes
                    switch vm.dataCondition {
                    case .loaded:
                        VStack(alignment: .center, spacing: 16) {
                            ForEach(vm.searchResultsList, id: \.id) { recipe in
                                NavigationLink {
                                    RecipeView(id: recipe.id)
                                } label: {
                                    RecipeFromSearchCard(recipe: recipe)
                                }
                            }
                        }
                    case .loading:
                        VStack {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .alert(vm.errorMessage, isPresented: $vm.showError) {}
            }
        }
    }
}

private struct IngredientTextfield: View {
    @Binding var text: String
    var body: some View {
        HStack {
            TextField("", text: $text)
                .clearButton(text: $text)
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customColor(.orange))
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchByIngredientsView()
    }
}
