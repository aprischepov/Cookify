//
//  HomeView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI
struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    var body: some View {
        ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center) {
                Button {
//                    get random recipe
                } label: {
                    Image("random")
                }
                Spacer()
                Button {
//                    profile screen
                } label: {
                    WebImage(url: vm.userProfile?.image).placeholder {
                        Image("avatar")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                }
            }
        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.customColor(.background))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .task {
            if vm.userProfile != nil { return }
            await vm.fetchUserData()
        }
        .refreshable {
//            refresh action
            vm.userProfile = nil
            await vm.fetchUserData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
