//
//  SignInViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 10.06.23.
//

import Foundation

final class SignInViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var isHiddenPassword = true
}
