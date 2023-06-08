//
//  Button.swift
//  Cookify
//
//  Created by Artem Prishepov on 8.06.23.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var body: some View {
        //        ZStack {
        //            Rectangle()
        //                .frame(height: 56)
        //                .foregroundColor(Color.customColor(.purple))
        //                .cornerRadius(24)
        //            Text("Log In")
        //                .font(.plusJacartaSans(.semiBold, size: 16))
        //            .foregroundColor(Color.customColor(.white))
        //        }
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .foregroundColor(.customColor(.orange))
            Text(title)
                .font(.jost(.medium, size: .body))
                .foregroundColor(.white)
        }
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Push me")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
