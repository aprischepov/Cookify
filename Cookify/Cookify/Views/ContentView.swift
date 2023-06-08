//
//  ContentView.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var vm = OnboardingViewModel()
    var body: some View {
        TabView(selection: $vm.selectedPage) {
            ForEach(OnboardingViewModel.onboardingCards) { viewData in
                OnboardingView(data: viewData, shouldOnboardingHidden: $vm.shouldOnboardingHidden)
                    .tag(viewData.id)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
