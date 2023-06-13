//
//  Extension + UIApplication.swift
//  Cookify
//
//  Created by Artem Prishepov on 13.06.23.
//

import Foundation
import UIKit

extension UIApplication {
    func rootController() -> UIViewController {
        guard let window = connectedScenes.first as? UIWindowScene,
              let viewController = window.windows.last?.rootViewController else { return .init()}
        return viewController
    }
}
