//
//  AddUserName.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct AddUserName: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack{
            HeaderRegisration()
                .padding(.horizontal, 16)
            
            VStack(alignment: .leading){
                Text("Your Account")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
              
                Text("Username")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 6){
                    CustomTextField(text: $viewModel.userName, textInfo: "Write your username", secureField: false, multiRow: false, search: false)
                    
                    if viewModel.allUserNames.contains(viewModel.userName.lowercased()){
                        Text("This username is already taken")
                            .font(.primaryFont(.P2))
                            .foregroundStyle(Color(.systemRed))
                    }
                }
                
                
                Text("Password")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
                CustomTextField(text: $viewModel.password, textInfo: "Create a password", secureField: true, multiRow: false, search: false)
                
                Text("Repeat password")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                VStack(alignment: .leading, spacing: 6){
                    CustomTextField(text: $viewModel.repeatPassword, textInfo: "Repeat your a password", secureField: true, multiRow: false, search: false)
                    
                    if viewModel.password != viewModel.repeatPassword && viewModel.repeatPassword != "" {
                        Text("The passwords dont match up")
                            .font(.primaryFont(.P2))
                            .foregroundStyle(Color(.systemRed))
                    }
                }
                
            }.padding(.horizontal)
                .padding(.top, 48)
            
        
            Button(action: {
                Task{
                    if !viewModel.allUserNames.contains(viewModel.userName.lowercased()) && viewModel.password == viewModel.repeatPassword{
                        try await viewModel.createUser()
                    }
                    
                }
            }){
                Text("Create Account")
                    .font(.primaryFont(.P1))
                    .foregroundStyle(.colorWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.colorOrange)
                    )
            }.padding(.horizontal)
                .padding(.top, 8)
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddUserName()
        .environmentObject(RegistrationViewModel(authService: AuthService()))
}
