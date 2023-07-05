//
//  ProfileView.swift
//  Cookify
//
//  Created by Artem Prishepov on 12.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    @StateObject private var user = AuthorizedUser.shared
    var body: some View {
        NavigationView {
            List {
                //                Profile Information
                Section {
                    Button {
                        vm.editProfile.toggle()
                    } label: {
                        HStack(alignment: .center, spacing: 16) {
                            WebImage(url: user.imageUrl).placeholder {
                                Image("avatar")
                                    .resizable()
                                    .frame(width: 56, height: 56)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(Color.customColor(.orange))
                            }
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(user.firstName ?? "Unkrnown") \(user.lastName ?? "User")")
                                    .font(.jost(.regular, size: .body))
                                    .foregroundColor(.customColor(.black))
                                Text(user.emailAddress ?? "Email")
                                    .font(.jost(.regular, size: .footnote))
                                    .foregroundColor(.customColor(.gray))
                            }
                        }
                    }
                    .sheet(isPresented: $vm.editProfile) {
                        EditProfileView()
                    }
                }
                Section {
                    ForEach(SettingsButtons.allCases, id: \.id) { button in
                        Button {
                            //                            action
                        } label: {
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: button.image)
                                Text(button.rawValue)
                            }
                        }
                    }
                    .foregroundColor(.customColor(.black))
                }
                //                Sign Out
                Section {
                    Button {
                        vm.signOut()
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .font(.jost(.regular, size: .body))
            }
        }
        .navigationTitle("Profile")
        .alert(vm.errorMessage, isPresented: $vm.showError) {}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
