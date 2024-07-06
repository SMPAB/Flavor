//
//  ForgottPassword.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import Lottie

struct ForgottPassword: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State var mail = ""
    @State var tryingToSendEmail = false
    @State var hasSentEmail = false
    var body: some View {
        VStack{
            HeaderRegisration()
                .padding(.horizontal, 16)
            
            VStack(alignment: .leading){
                Text("Type in you email")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                ZStack(alignment: .trailing){
                    CustomTextField(text: $mail, textInfo: "type in your mail", secureField: false, multiRow: false, search: false)
                    
                    if tryingToSendEmail{
                        LottieView(animation: .named("Checkmark"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }.frame(maxWidth: .infinity)
                
                
                Button(action: {
                    tryingToSendEmail = true
                    Task{
                        try await viewModel.forgotPassword(forEmail: mail)
                        hasSentEmail = true
                        mail = ""
                    }
                }){
                    Text("Reset password")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(.colorWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 53)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.colorOrange)
                        )
                }.padding(.top, 8)
            }.padding(.horizontal, 16)
                .padding(.top, 46)
            
            Spacer()
        }
    }
}

#Preview {
    ForgottPassword()
        .environmentObject(LoginViewModel(authService: AuthService()))
}
