//
//  ContentView.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm = OnboardingCardViewModel()
    var body: some View {
        TabView(selection: $vm.selectedPage) {
            ForEach(OnboardingCards.allCases) { viewData in
                OnboardingCardView(data: viewData, shouldOnboardingHidden: $vm.shouldOnboardingHidden)
                    .tag(viewData.id)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
