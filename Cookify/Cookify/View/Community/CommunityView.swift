//
//  CommunityView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import Combine

struct CommunityView: View {
    @ObservedObject var vm: CommunityViewModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Reviews")
                    .font(.jost(.semiBold, size: .largeTitle))
                    .padding(.horizontal, 16)
                if vm.reviews.isEmpty {
                    EmptyListView(type: .emptyReviews)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack {
                            ForEach(vm.reviews, id: \.uid) { review in
                                ReviewView(review: review)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .refreshable {
                vm.sendAction(actionType: .reloadReviwsList)
            }
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(vm: CommunityViewModel(subject: PassthroughSubject<ActionsWithRecipes, Never>()))
    }
}
