//
//  RatingView.swift
//  Cookify
//
//  Created by Artem Prishepov on 5.07.23.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    private let maxRating: Int = 5
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...maxRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundColor(.customColor(number <= rating ? .orange : .gray))
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func showStar(for number: Int) -> Image {
        number > rating ? Image("starIcon") : Image("starFillIcon")
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
