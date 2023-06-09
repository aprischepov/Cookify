//
//  OnboardingView.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.06.23.
//

import SwiftUI

enum AppCondition: String {
    case onboarding
    case signIn
    case signOut
}

struct OnboardingView: View {
    var data: Onboarding
    @Binding var shouldOnboardingHidden: Bool
    @AppStorage("appCondition", store: .standard) var appCondition: AppCondition = .onboarding
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 16) {
                //                Title onboarding card
                Text(data.title)
                    .font(.jost(.medium, size: .largeTitle))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                //                Text onboarding card
                Text(data.body)
                    .font(.jost(.regular, size: .body))
                    .frame(height: 115)
                    .minimumScaleFactor(0.01)
                    .foregroundColor(.customColor(.darkGray))
                    .padding(.bottom, 16)
                //                Finish onboarding button
                Button {
                    shouldOnboardingHidden.toggle()
                    appCondition = .signOut
                } label: {
                    CustomButton(title: "Finish")
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .opacity(data.id == 3 ? 1 : 0)
                .fullScreenCover(isPresented: $shouldOnboardingHidden, content: {
                    SignInView()
                })
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 30, style: .circular)
            )
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(
            Image(data.image)
                .ignoresSafeArea()
        )
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(data: Onboarding.firstPage, shouldOnboardingHidden: .constant(false))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        //            .previewDisplayName("iPhonew 14 Pro Max")
        //        OnboardingView(data: OnboardingData.list.first!)
        //            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        //            .previewDisplayName("iPhone SE")
    }
}
