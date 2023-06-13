//
//  CustomFunction.swift
//  Cookify
//
//  Created by Artem Prishepov on 13.06.23.
//

import Foundation
import UIKit
import SwiftUI

protocol CustomFunctionProtocol {
    func closeKeyboard()
}

final class CustomFunction: CustomFunctionProtocol {
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
