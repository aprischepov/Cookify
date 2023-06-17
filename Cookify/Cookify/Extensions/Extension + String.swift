//
//  Extension + String.swift
//  Cookify
//
//  Created by Artem Prishepov on 15.06.23.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
