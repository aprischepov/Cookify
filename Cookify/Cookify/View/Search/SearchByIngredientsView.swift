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
        VStack(alignment: .leading, spacing: 16) {
            Text("Which ingredients are available?")
                .font(.jost(.semiBold, size: .title))
                .foregroundColor(.customColor(.black))
            VStack {
                ForEach($vm.texfieldsList, id: \.self) { $text in
                    IngredientTextfield(text: $text) {
                        vm.actionTextfield()
                    }
                }
            }
            .font(.jost(.regular, size: .callout))
            Button("Add ingredient") {
                vm.addTextfield()
            }
            .font(.jost(.medium, size: .callout))
            .opacity(vm.texfieldsList.count == 3 ? 0 : 1)
            Button {
//                send api
            } label: {
                CustomButton(title: "Find recipes",
                             style: .filledButton)
            }
            .opacity(vm.isButtonActivated ? 1 : 0.7)
            .disabled(!vm.isButtonActivated)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .alert(vm.errorMessage, isPresented: $vm.showError) {}
    }
}

private struct IngredientTextfield: View {
    @Binding var text: String
    var action: () -> Void
    var body: some View {
        HStack {
            TextField("", text: $text)
            Button {
                action()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.customColor(.orange))
                    .bold()
            }
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
