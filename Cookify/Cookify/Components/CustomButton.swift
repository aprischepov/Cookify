//
//  Button.swift
//  Cookify
//
//  Created by Artem Prishepov on 8.06.23.
//

import SwiftUI

enum StyleCustomButton {
    case filledButton
    case borderButton
    case googleButton
    case appleButton
}

struct CustomButton: View {
    var title: String
    var style: StyleCustomButton
    var body: some View {
        ZStack {
            switch style {
            case .filledButton:
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.customColor(.orange))
                Text(title)
                    .foregroundColor(.customColor(.white))
            case .appleButton:
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.customColor(.black))
                    Text(title)
                        .foregroundColor(.customColor(.black))
                }
            case .borderButton:
                Text(title)
                    .foregroundColor(.customColor(.orange))
            case .googleButton:
                HStack(alignment: .center, spacing: 4) {
                    Image("google")
                    Text(title)
                        .foregroundColor(.customColor(.orange))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 48)
        .font(.jost(.medium, size: .body))
        .overlay {
            switch style {
            case .filledButton:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.clear)
            case .borderButton, .googleButton:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customColor(.orange))
            case .appleButton:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customColor(.black))
            }
        }
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Sign In", style: .filledButton)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
