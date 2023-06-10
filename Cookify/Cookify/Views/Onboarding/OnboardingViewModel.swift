//
//  OnboardingViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.06.23.
//

import Foundation

enum Onboarding: Identifiable, CaseIterable {
    case firstPage
    case secondPage
    case thirdPage
    case fourthPage
    
    var id: Int {
        switch self {
        case .firstPage:
            return 0
        case .secondPage:
            return 1
        case .thirdPage:
            return 2
        case .fourthPage:
            return 3
        }
    }
    var image: String {
        switch self {
        case .firstPage:
            return "onboardingFirst"
        case .secondPage:
            return "onboardingSecond"
        case .thirdPage:
            return "onboardingThird"
        case .fourthPage:
            return "onboardingFourth"
        }
    }
    var title: String {
        switch self {
        case .firstPage:
            return "Explore"
        case .secondPage:
            return "Save recipes"
        case .thirdPage:
            return "Share"
        case .fourthPage:
            return "Create a grocery list"
        }
    }
    var body: String {
        switch self {
        case .firstPage:
            return "Browse through our collection of delicious recipes and find something that inspires you. From classic comfort foods to healthy weeknight dinners, we've got you covered."
        case .secondPage:
            return "Found a recipe that you love? Save it to your favourites so you can easily access it later. You can also create custom recipe collections to keep your favourite recipes organized."
        case .thirdPage:
            return "Have a recipe that you think your friends would love? Share it with them directly from the app via text, email, or social media."
        case .fourthPage:
            return "Tired of forgetting ingredients while you're at the store? Create a shopping list directly from the recipe, so you always have everything you need."
        }
    }
}

final class OnboardingViewModel: ObservableObject {
    @Published var selectedPage = 0
    @Published var shouldOnboardingHidden = false
}
