//
//  EditProfileView.swift
//  Cookify
//
//  Created by Artem Prishepov on 17.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = EditProfileViewModel()
    @State var imageData: Data?
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            //                User Image
            Button {
                vm.showImagePicker.toggle()
            } label: {
                    WebImage(url: URL(string: vm.userImage)).placeholder {
                        Image("avatar")
                            .resizable()
                            .frame(width: 96, height: 96)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 96, height: 96)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.customColor(.orange), lineWidth: 2)
                    }
            }
            
            //                User Info
            VStack(alignment: .center, spacing: 8) {
                CustomTextField(title: "First Name",
                                placeholder: "",
                                textFieldType: .defaultTextField,
                                inputText: $vm.inputUserFirstName,
                                keyboardType: .default)
                CustomTextField(title: "Last Name",
                                placeholder: "",
                                textFieldType: .defaultTextField,
                                inputText: $vm.inputUserLastName,
                                keyboardType: .default)
                CustomTextField(title: "Email Address",
                                placeholder: "",
                                textFieldType: .defaultTextField,
                                inputText: $vm.inputUserEmail,
                                keyboardType: .emailAddress)
            }
            Spacer()
            
            //                Update Profile Data
            Button {
                vm.updateData()
                dismiss()
            } label: {
                CustomButton(title: "Update",
                             style: .filledButton)
            }
            .opacity(vm.isActivedButton ? 1 : 0.7)
            .disabled(!vm.isActivedButton)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .sheet(isPresented: $vm.showImagePicker) {
            ImagePicker(imageUrl: $vm.userImage)
        }
        .alert(vm.errorMessage, isPresented: $vm.showError) {}
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
