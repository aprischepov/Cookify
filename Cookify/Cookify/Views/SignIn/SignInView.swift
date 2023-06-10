//
//  SignInView.swift
//  Cookify
//
//  Created by Artem Prishepov on 8.06.23.
//

import SwiftUI

struct SignInView: View {
    @StateObject var vm = SignInViewModel()
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
            Spacer()
            VStack(alignment: .center, spacing: 8) {
                CustomTextField(title: "Email Address",
                                placeholder: "example@gmail.com",
                                textFieldType: .defaultTextField,
                                inputText: $vm.emailAddress)
                CustomTextField(title: "Password",
                                placeholder: "password",
                                textFieldType: .passwordTextField,
                                inputText: $vm.password,
                                isHiddenPassword: $vm.isHiddenPassword)
            }
            Spacer()
            VStack(alignment: .center, spacing: 24) {
                Button {
                    //                sign in method
                } label: {
                    CustomButton(title: "Sign In",
                                 style: .filledButton)
                }
                
                Text("Or continue with social account")
                    .font(.jost(.regular, size: .footnote))
                    .foregroundColor(.customColor(.gray))
//                MARK: - Sign in with social media
                VStack(alignment: .center, spacing: 16) {
                    Button {
                        //                    sign in with google
                    } label: {
                        CustomButton(title: "Sign In with Google",
                                     style: .googleButton)
                    }
                    
                    Button {
                        //                    sign in with apple
                    } label: {
                        CustomButton(title: "Sign In with Apple",
                                     style: .appleButton)
                    }
                }
            }
            Spacer()
            HStack(alignment: .center, spacing: 4) {
                Text("Didn’t have an account?")
                Button {
//                    register new user
                } label: {
                    Text("Register")
                        .foregroundColor(.customColor(.orange))
                }

            }
            .font(.jost(.medium, size: .footnote))
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.customColor(.background))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
