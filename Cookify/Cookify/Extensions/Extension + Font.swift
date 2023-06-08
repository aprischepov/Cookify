//
//  Extension + Font.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.06.23.
//

import Foundation
import SwiftUI

enum FontName: String {
    case light = "Jost-Light"
    case regular = "Jost-Regular"
    case medium = "Jost-Medium"
    case bold = "Jost-Bold"
}

enum FontSize: CGFloat {
    case largeTitle = 32
    case body = 18
}

extension Font {
    static func jost(_ font: FontName, size: FontSize) -> Font {
        custom(font.rawValue, size: size.rawValue)
    }
}
