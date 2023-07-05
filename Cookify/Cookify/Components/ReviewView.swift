//
//  ReviewView.swift
//  Cookify
//
//  Created by Artem Prishepov on 5.07.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReviewView: View {
    var review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 16) {
                //                User Image
                WebImage(url: URL(string: review.userImage)).placeholder{
                    Image("avatar")
                        .resizable()
                        .frame(width: 56, height: 56)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.customColor(.orange))
                }
                //                User Name and Date
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(review.firstName) \(review.lastName)")
                        .font(.jost(.regular, size: .body))
                        .foregroundColor(.customColor(.black))
                    Text(review.publishedDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.jost(.light, size: .callout))
                        .foregroundColor(.customColor(.darkGray))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            //            Title
            Text(review.recipeTitle)
                .font(.jost(.bold, size: .title))
            HStack(spacing: 0) {
                ForEach(1...review.rating, id: \.self) { number in
                    Image("starFillIcon")
                        .foregroundColor(.customColor(.orange))
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(0..<review.images.count, id: \.self) { index in
                        WebImage(url: URL(string: review.images[index])).placeholder{
                            Image("cookifyIcon")
                                .opacity(0.3)
                        }
                        .resizable()
                        .frame(width: 128, height: 128)
                        .scaledToFit()
                        .cornerRadius(10)
                    }
                }
            }
            Text(review.text)
                .font(.jost(.regular, size: .body))
                .foregroundColor(.customColor(.black))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(review: Review(text: "Good recipe!", recipeTitle: "Vegetarian food", recipeId: 12345, images: ["", ""], publishedDate: Date(), rating: 4, firstName: "Alex", lastName: "Swift", userUID: "1234", userImage: ""))
    }
}
