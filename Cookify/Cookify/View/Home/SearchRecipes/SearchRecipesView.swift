//
//  SearchView.swift
//  Cookify
//
//  Created by Artem Prishepov on 20.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchRecipesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SearchRecipesViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 16) {
                HStack(alignment: .center, spacing: 8) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.customColor(.orange))
                            .bold()
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 48)
                            .foregroundColor(.customColor(.lightGray))
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.customColor(.gray))
                            TextField("Hungry? ", text: $vm.inputSearchText)
                                .font(.jost(.regular, size: .body))
                            Button {
                                vm.inputSearchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.customColor(.darkGray))
                            }
                            .opacity(vm.inputSearchText.isEmpty ? 0 : 1)
                        }
                        .padding(.horizontal, 8)
                    }
                }
                    List(vm.recipesList, id: \.id) { recipe in
                        HStack(alignment: .center, spacing: 8) {
                            WebImage(url: URL(string: "https://spoonacular.com/recipeImages/\(recipe.id)-312x231.\(recipe.imageType)")).placeholder{
                                ZStack {
                                    Image("cookifyIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .opacity(0.3)
                                }
                                .frame(height: 40)
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            Text(recipe.title)
                                .font(.jost(.medium, size: .body))
                        }
                    }
                    .listStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .alert(vm.errorMessage, isPresented: $vm.showError) {}
        }
            
        }
    }
    
    struct SearchRecipesView_Previews: PreviewProvider {
        static var previews: some View {
            SearchRecipesView()
        }
    }
