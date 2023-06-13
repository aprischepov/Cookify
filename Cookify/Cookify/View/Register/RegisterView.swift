//
//  RegisterView.swift
//  Cookify
//
//  Created by Artem Prishepov on 10.06.23.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var vm = RegistrationViewModel()
    @AppStorage("appCondition") var appCondition: AppCondition?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            VStack(alignment: .center, spacing: 8) {
                CustomTextField(title: "First Name",
                                placeholder: "",
                                textFieldType: .defaultTextField,
                                inputText: $vm.firstName,
                                keyboardType: .default)
                CustomTextField(title: "Last Name",
                                placeholder: "",
                                textFieldType: .defaultTextField,
                                inputText: $vm.lastName,
                                keyboardType: .default)
                CustomTextField(title: "Email Address",
                                placeholder: "",
                                textFieldType: .defaultTextField,
                                inputText: $vm.emailAddress,
                                keyboardType: .emailAddress)
                CustomTextField(title: "Password",
                                placeholder: "",
                                textFieldType: .passwordTextField,
                                inputText: $vm.password,
                                isHiddenPassword: $vm.isHiddenPassword,
                                keyboardType: .default)
                CustomTextField(title: "Confirm Password",
                                placeholder: "",
                                textFieldType: .passwordTextField,
                                inputText: $vm.confirmedPassword,
                                isHiddenPassword: $vm.isHiddenConfirmedPassword,
                                keyboardType: .default)
            }
            Button {
//                sign up button
                vm.registerUser()
            } label: {
                CustomButton(title: "Sign Up", style: .filledButton)
            }
            .opacity(vm.activateButton() ? 1 : 0.7)
            .disabled(!vm.activateButton())
            Spacer()
            HStack(alignment: .top, spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.customColor(.black))
                Button {
                    dismiss()
                } label: {
                    Text("Sign In")
                        .foregroundColor(.customColor(.orange))
                }

            }
            .font(.jost(.medium, size: .footnote))

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .navigationTitle("Create Account")
        .overlay(content: {
            LoadingView(show: $vm.isLoading)
        })
//        Alert with firebase error
        .alert(vm.errorMessage, isPresented: $vm.showError) {}
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
