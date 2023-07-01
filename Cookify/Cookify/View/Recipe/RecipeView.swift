//
//  Recipe.swift
//  Cookify
//
//  Created by Artem Prishepov on 27.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeView: View {
    @StateObject private var vm: RecipeViewModel
    init(id: Int) {
        _vm = StateObject(wrappedValue: RecipeViewModel(id: id))
    }
    var body: some View {
        switch vm.dataCondition {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        case .loaded:
            ScrollView(.vertical, showsIndicators: false) {
                if let recipeInfo = vm.recipeInfo {
                    VStack(spacing: 0) {
                        //                Image
                        WebImage(url: URL(string: recipeInfo.image)).placeholder {
                            Image("cookifyIcon")
                                .opacity(0.3)
                                .frame(maxWidth: .infinity, maxHeight: 320, alignment: .center)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(height: 320)
                        VStack(alignment: .center, spacing: 8) {
                            //                    Title and Ready in Minutes
                            HStack(alignment: .center, spacing: 4) {
                                Text(recipeInfo.title)
                                    .font(.jost(.medium, size: .title))
                                Spacer()
                                Image(systemName: "clock")
                                    .foregroundColor(.customColor(.orange))
                                    .bold()
                                Text("\(recipeInfo.readyInMinutes) min")
                                    .font(.jost(.regular, size: .body))
                                    .foregroundColor(.customColor(.gray))
                            }
                            .padding(.horizontal, 16)
                            //                    Health Score
                            HStack(spacing: 8) {
                                Text("Health Score:")
                                    .font(.jost(.semiBold, size: .body))
                                Text(recipeInfo.healthScore.formatted(.percent))
                                    .foregroundColor(.customColor(.darkGray))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.customColor(.lightOrange))
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            //                    Summary
                            Text(vm.summary)
                                .font(.jost(.regular, size: .body))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                            //                    Nutrients
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(vm.nutrients, id: \.id) { nutrient in
                                    HStack {
                                        Image(nutrient.type.icon)
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding(4)
                                            .background {
                                                Color.customColor(.lightOrange)
                                            }
                                            .cornerRadius(5)
                                        
                                        Text(nutrient.text)
                                            .font(.jost(.regular, size: .footnote))
                                            .foregroundColor(.customColor(.darkGray))
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            //                    Ingridients / Instructions
                            HStack(alignment: .center, spacing: 0) {
                                ForEach(RecipeInfoType.allCases, id: \.id) { type in
                                    Button {
                                        vm.currentType = type
                                    } label: {
                                        Spacer()
                                        Text(type.rawValue)
                                            .foregroundColor(.customColor(vm.currentType == type ? .white : .orange))
                                            .font(.jost(.regular, size: .body))
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    .background {
                                        Color.customColor(vm.currentType == type ? .orange : .lightGray)
                                    }
                                }
                            }
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                            switch vm.currentType {
                            case .ingredients:
                                IngredientsView(ingredients: vm.ingredients)
                            case .instructions:
                                InstructionView(instruction: vm.steps)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

private struct IngredientsView: View {
    var ingredients: [IngredientModel]
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            ForEach(ingredients, id: \.id) { ingredient in
                HStack(spacing: 16) {
                    Text(ingredient.text)
                        .frame(maxWidth: 128, alignment: .leading)
                        .foregroundColor(.customColor(.darkGray))
                    Text(ingredient.name)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                //                                add to shopping list action
            } label: {
                CustomButton(title: "Add to shopping list", style: .filledButton)
            }
            
        }
        .font(.jost(.regular, size: .body))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

private struct InstructionView: View {
    var instruction: [Step]
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ForEach(instruction, id: \.number) { step in
                HStack(alignment: .top, spacing: 8) {
                    Text(step.number.description)
                        .foregroundColor(.customColor(.gray))
                        .font(.jost(.medium, size: .body))
                        .frame(width: 24)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color.customColor(.orange))
                        }
                    Text(step.step)
                        .font(.jost(.regular, size: .body))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                //                                Share to Community
            } label: {
                CustomButton(title: "Share to community", style: .filledButton)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 16)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(id: 654959)
    }
}
