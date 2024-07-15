//
//  SetupAccount.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-13.
//

import SwiftUI

struct SetupAccount: View {
    
    @EnvironmentObject var viewModel: UserControllViewModel
    @State var userName = ""
    @State var showErrorUsernameExists = false
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                
                Image(.logoFullBlack)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 88)
                Spacer()
            }
            
            VStack(alignment: .leading){
                Text("Create Username")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                CustomTextField(text: $userName, textInfo: "Username...", secureField: false, multiRow: false, search: false)
                   
                if showErrorUsernameExists {
                    Text("username exists")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(Color(.systemRed))
                }
                
                CustomButton(text: "Set up account", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                    Task{
                        if !viewModel.allUsernames.contains(userName.lowercased()){
                            try await viewModel.createAccount(userName: userName)
                        } else {
                            showErrorUsernameExists = true
                        }
                        
                    }
                }).padding(.top, 8)
            } .padding(16)
            
            Spacer()
        }
    }
}

#Preview {
    SetupAccount()
}
