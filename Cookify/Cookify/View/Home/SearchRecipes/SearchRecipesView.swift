//
//  SearchView.swift
//  Cookify
//
//  Created by Artem Prishepov on 20.06.23.
//

import SwiftUI

struct SearchRecipesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SearchRecipesViewModel()
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 48)
                    .foregroundColor(.customColor(.lightGray))
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.customColor(.gray))
                    TextField("Search", text: $vm.inputSearchText)
                        .font(.jost(.regular, size: .body))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)

    }
}

struct SearchRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecipesView()
    }
}
