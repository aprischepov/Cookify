//
//  EmptyListView.swift
//  Cookify
//
//  Created by Artem Prishepov on 3.07.23.
//

import SwiftUI

struct EmptyListView: View {
    var type: EmptyList
    var body: some View {
        VStack(alignment:.center, spacing: 8) {
            Image(type.rawValue)
            Text(type.title)
                .font(.jost(.medium, size: .title))
                .multilineTextAlignment(.center)
            Text(type.text)
                .font(.jost(.regular, size: .body))
        }
        .padding(.horizontal, 16)
    }
}

enum EmptyList: String {
    case emptyShoppingList = "emptyShoppingList"
    case emptyFavoritesList = "emptyFavoritesList"
    case emptySearchList = "emptySearchList"
    case emptyNotFound = "emptyNotFound"
    case emptyReviews = "emptyReviews"
    
    var title: String {
        switch self {
        case .emptyShoppingList:
            return "You don't have recipes on your shopping list yet."
        case .emptyFavoritesList:
            return "Looks like you haven't liked anything yet!"
        case .emptySearchList:
            return "We're sorry!"
        case .emptyNotFound:
            return "Oops!"
        case .emptyReviews:
            return "Here it is empty..."
        }
    }
    
    var text: String {
        switch self {
        case .emptyShoppingList:
            return "When you add ingredients to your shopping list, you'll see them here. Happy shopping!"
        case .emptyFavoritesList:
            return "Looks like you haven't liked anything yet! If you love a recipe simply tap on the heart to save it for later. It’ll be right here waiting for you."
        case .emptySearchList:
            return "We could not find any results for your search. Please try a different search term!"
        case .emptyNotFound:
            return "Before, there was something here..."
        case .emptyReviews:
            return "But you can write the first review."
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(type: .emptyShoppingList)
    }
}
