//
//  Extension + View.swift
//  Cookify
//
//  Created by Artem Prishepov on 20.06.23.
//

import Foundation
import SwiftUI

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}
