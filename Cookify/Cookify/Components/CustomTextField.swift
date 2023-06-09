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
}

struct CustomTextField: View {
    var title: String
    var placeholder: String
    let textFieldType: TextFieldType
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Name", placeholder: "Artem", textFieldType: .defaultTextField)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
