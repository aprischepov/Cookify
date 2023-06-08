//
//  OnboardingModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.06.23.
//

import Foundation

struct OnboardingData: Hashable, Identifiable {
    var id: Int
    var image: String
    var title: String
    var body: String
}
