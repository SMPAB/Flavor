//
//  MainRegistrationView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct MainRegistrationView: View {
    
    @StateObject var viewModel: RegistrationViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    init(authService: AuthService){
        self._viewModel = StateObject(wrappedValue: RegistrationViewModel(authService: authService))
    }
    var body: some View {
        VStack{
            HeaderRegisration()
                .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 16){
                Text("Sign Up")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                VStack(alignment: .center, spacing: 8){
                    Text("Email")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 153, height: 2)
                    
                }
                
                CustomTextField(text: $viewModel.email, textInfo: "Eg. emilio.martinez@flavor", secureField: false)
                
                Text("By continuing and signing up, you are creating a Flavor account and agree to Flavors")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
                +
                Text(" Terms")
                    .font(.primaryFont(.P2))
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorOrange)
                +
                Text(" and")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                +
                Text(" Privacy policy")
                    .font(.primaryFont(.P2))
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorOrange)
                
                if viewModel.email.contains("@"){
                    NavigationLink(destination:
                                    AddUserName()
                        .environmentObject(viewModel)
                    ){
                        Text("Continue")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 53)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.colorOrange)
                            )
                    }
                } else {
                    Text("Continue")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(.colorWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 53)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.colorOrange)
                            .opacity(0.6)
                        )
                    
                }
                
                
                Button(action: {
                    Task{
                      try await loginViewModel.signInGoogle()
                    }
                }){
                    HStack{
                        
                        Image("Icon_Google")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                        Spacer()
                        
                        Text("Continue with google")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .frame(height: 53)
                            .frame(maxWidth: .infinity)
                           
                        Spacer()
                        
                        Image("Icon_Google")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .opacity(0)
                    }.padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                        )
                }
                
            }.padding(.horizontal, 16)
                .padding(.top, 48)
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onFirstAppear {
                Task{
                    try await viewModel.fetchAllUsernames()
                }
            }
    }
}

#Preview {
    MainRegistrationView(authService: AuthService())
        .environmentObject(LoginViewModel(authService: AuthService()))
}
