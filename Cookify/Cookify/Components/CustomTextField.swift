//
//  CustomTextField.swift
//  Cookify
//
//  Created by Artem Prishepov on 8.06.23.
//

import SwiftUI

enum TextFieldType {
    case defaultTextField
    case passwordTextField
    
    var charactersLimit: Int {
        switch self {
        case .defaultTextField:
            return 30
        case .passwordTextField:
            return 10
        }
    }
}

struct CustomTextField: View {
    var title: String
    var placeholder: String
    let textFieldType: TextFieldType
    var keyboardType: UIKeyboardType
    @Binding var inputText: String
    @Binding var isHiddenPassword: Bool
    let specialCharacters = " !#$%&'()*+,/:;<=>?[\\]^`{|}~"
    
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
                case .passwordTextField where isHiddenPassword:
                    SecureField(placeholder, text: $inputText)
                        .keyboardType(keyboardType)
                        .onChange(of: inputText) { newValue in
                            inputText = String(inputText.prefix(textFieldType.charactersLimit).filter{ !specialCharacters.contains($0) })
                        }
                default:
                    TextField(placeholder, text: $inputText)
                        .keyboardType(keyboardType)
                        .onChange(of: inputText) { newValue in
                            inputText = String(inputText.prefix(textFieldType.charactersLimit).filter{ !specialCharacters.contains($0) })
                        }
                }
            }
            Spacer()
            if textFieldType == .passwordTextField {
                Button {
                    isHiddenPassword.toggle()
                } label: {
                    Image(systemName: isHiddenPassword ? "eye.slash" : "eye.fill")
                        .foregroundColor(.customColor(.orange))
                }
                
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customColor(.orange))
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Password", placeholder: "Password", textFieldType: .defaultTextField, inputText: .constant(""), keyboardType: .default)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
