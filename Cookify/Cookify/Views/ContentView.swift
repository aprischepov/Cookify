//
//  ContentView.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.05.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = OnboardingViewModel()
    var body: some View {
        TabView(selection: $vm.selectedPage) {
            ForEach(Onboarding.allCases) { viewData in
                OnboardingView(data: viewData)
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
