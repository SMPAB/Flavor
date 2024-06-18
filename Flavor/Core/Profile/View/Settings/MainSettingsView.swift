//
//  MainSettingsView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI
import Iconoir

struct MainSettingsView: View {
    @Environment(\.dismiss) var dismiss
    //@EnvironmentObject var contentViewmodel: ContentViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    // State to manage the visibility of the delete alert
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.black)
                }
                
                Spacer()
                
                Text("Settings")
                    .font(.custom("HankenGrotesk-Regular", size: 24)) // Assuming .H4 maps to a font size of 24
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.left")
                    .opacity(0)
            }
            
            //MARK: PREFERENCES
            
            VStack (alignment: .leading){
                
                Text("Preferences")
                    .font(.primaryFont(.P1))
                    .foregroundStyle(Color(.systemGray))
                    .fontWeight(.semibold)
                VStack {
                    
                    NavigationLink(destination:
                    MainBlockView()
                        .environmentObject(profileVM)
                        .navigationBarBackButtonHidden(true)
                    ) {
                        HStack {
                            Iconoir.minusCircle.asImage
                            Text("Blocked")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.foregroundStyle(Color(.systemGray))
                    }
                }.padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.colorWhite)
                        .shadow(radius: 3)
            )
            }
            
            Rectangle()
                .fill(Color(.systemGray))
                .frame(height: 1)
            
            VStack (alignment: .leading){
                
                Text("Flavor details")
                    .font(.primaryFont(.P1))
                    .foregroundStyle(Color(.systemGray))
                    .fontWeight(.semibold)
                VStack {
                    
                    Link(destination: URL(string: "https://www.flavorapp.se/")!) {
                        HStack {
                            Iconoir.mail.asImage
                            Text("Contact")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.foregroundStyle(Color(.systemGray))
                    }
                }.padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.colorWhite)
                        .shadow(radius: 3)
            )
            }
            
            
            Rectangle()
                .fill(Color(.systemGray))
                .frame(height: 1)
            
            
            //MARK: OTHER SETTINGS
            
            VStack {
                Button(action: {
                    AuthService.shared.signout()
                    AuthService.shared.userSession = nil
                    contentViewModel.userSession = nil
                    //contentViewmodel.currentUser = nil
                    //contentViewmodel.userSession = nil
                }) {
                    HStack {
                        Iconoir.logOut.asImage
                        Text("Sign out")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.foregroundStyle(Color(.colorOrange))
                }
                
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                
                Button(action: {
                    // Show delete confirmation alert
                    showingDeleteAlert = true
                }) {
                    HStack {
                        Iconoir.trash.asImage
                        Text("Delete account")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.foregroundStyle(Color(.colorOrange))
                }
            }.padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.colorWhite)
                    .shadow(radius: 3)
            )
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color(.colorWhite))
        .navigationBarBackButtonHidden(true)
        // Alert modifier to handle account deletion
        .alert("Delete Account", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to permanently delete your account?")
        }
    }
    
    func deleteAccount() {
        Task{
            try await UserService.deleteAccount(profileVM.user)
            AuthService.shared.signout()
            AuthService.shared.userSession = nil
            contentViewModel.userSession = nil
        }
    }
}

// You can keep the Preview section unchanged.

#Preview {
    MainSettingsView()
}
