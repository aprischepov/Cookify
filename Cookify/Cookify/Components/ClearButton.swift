//
//  ClearButton.swift
//  Cookify
//
//  Created by Artem Prishepov on 30.06.23.
//

import Foundation
import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.customColor(.orange)).opacity(0.8)
                }
                .padding(.trailing, 8)
            }
        }
    }
}
