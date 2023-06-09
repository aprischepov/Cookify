//
//  SignInView.swift
//  Cookify
//
//  Created by Artem Prishepov on 8.06.23.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("cookifyIcon")
                .padding(.bottom, 16)
            Group {
                Text("Welcome Back 👋")
                    .foregroundColor(.customColor(.black))
                Text("to ")
                    .foregroundColor(.customColor(.black)) +
                Text("Cookify")
                    .foregroundColor(.customColor(.orange))
            }
            .font(.jost(.semiBold, size: .title))
            .frame(maxHeight: 24)
            Text("Hello there, login to continue")
                .font(.jost(.regular, size: .footnote))
                .foregroundColor(.customColor(.gray))
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.customColor(.background))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
