//
//  OnboardingViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.06.23.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var selectedPage = 0
    @Published var shouldOnboardingHidden = false
    static let onboardingCards = [
        OnboardingData(id: 0, image: "onboardingFirst", title: "Explore", body: "Browse through our collection of delicious recipes and find something that inspires you. From classic comfort foods to healthy weeknight dinners, we've got you covered."),
        OnboardingData(id: 1, image: "onboardingSecond", title: "Save recipes", body: "Found a recipe that you love? Save it to your favourites so you can easily access it later. You can also create custom recipe collections to keep your favourite recipes organized."),
        OnboardingData(id: 2, image: "onboardingThird", title: "Share", body: "Have a recipe that you think your friends would love? Share it with them directly from the app via text, email, or social media."),
        OnboardingData(id: 3, image: "onboardingFourth", title: "Create a grocery list", body: "Tired of forgetting ingredients while you're at the store? Create a shopping list directly from the recipe, so you always have everything you need.")
    ]
}
