//
//  Extension + Color.swift
//  Cookify
//
//  Created by Artem Prishepov on 7.06.23.
//

import Foundation
import SwiftUI

enum Colors: String {
    case orange = "orange"
    case white = "white"
    case darkGray = "darkGray"
}

extension Color {
    static func customColor(_ color: Colors) -> Color {
        return Color(color.rawValue)
    }
}
