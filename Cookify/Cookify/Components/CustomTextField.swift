//
//  CustomTextField.swift
//  Cookify
//
//  Created by Artem Prishepov on 8.06.23.
//

import SwiftUI
import Combine

enum TextFieldType {
    case defaultTextField
    case passwordTextField
}

struct CustomTextField: View {
    var title: String
    var placeholder: String
    let textFieldType: TextFieldType
    var keyboardType: UIKeyboardType
    @Binding var inputText: String
    @Binding var isHiddenPassword: Bool
    
    init(title: String, placeholder: String, textFieldType: TextFieldType, inputText: Binding<String>, isHiddenPassword: Binding<Bool> = .constant(false), keyboardType: UIKeyboardType) {
        self.title = title
        self.placeholder = placeholder
        self.textFieldType = textFieldType
        self._inputText = inputText
        self._isHiddenPassword = isHiddenPassword
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.jost(.regular, size: .caption))
                    .foregroundColor(.customColor(.orange))
                switch textFieldType {
                case .defaultTextField:
                    TextField(placeholder, text: $inputText)
                        .keyboardType(keyboardType)
                case .passwordTextField:
                    if isHiddenPassword {
                        SecureField(placeholder, text: $inputText)
                            .keyboardType(keyboardType)
                    } else {
                        TextField(placeholder, text: $inputText)
                            .keyboardType(keyboardType)
                    }
                }
            }
            Spacer()
            if textFieldType == .passwordTextField {
                Button {
                    isHiddenPassword.toggle()
                } label: {
                    Image(systemName: isHiddenPassword ? "eye.fill" : "eye.slash")
                        .foregroundColor(.customColor(.orange))
                }

            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: 56)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customColor(.orange))
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Password", placeholder: "strongPassword", textFieldType: .passwordTextField, inputText: .constant(""), keyboardType: .default)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
