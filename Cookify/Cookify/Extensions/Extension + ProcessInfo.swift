//
//  Extension + ProcessInfo.swift
//  Cookify
//
//  Created by Artem Prishepov on 28.06.23.
//

import Foundation

public extension ProcessInfo {
    
    static var isPreviewMode: Bool {
        if let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"], isPreview == "1" {
            return true
        } else {
            return false
        }
    }
    
}
