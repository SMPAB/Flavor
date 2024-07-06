//
//  LoginView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @State var showBackground = false
    @State var email = ""
    @State var password = ""
    
    @StateObject var viewModel: LoginViewModel
    @State var paddingBottom: CGFloat = 0
    
    @State var showShouldSignInWithGoogle = false
    
    @FocusState var isfocused
    init(authservice: AuthService){
        self._viewModel = StateObject(wrappedValue: LoginViewModel(authService: authservice))
    }
    var body: some View {
        NavigationStack {
            ZStack(){
                
                    GifImageView("background")
                        .scaleEffect(1.3)
                
                if !showBackground{
                    Image("GradientStill")
                        .scaleEffect(1.3)
                }
                
                VStack{
                    Image("Logo_Single_White")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 110)
                    
                    Text("Welcome")
                        .font(.primaryFont(.H2))
                        .fontWeight(.semibold)
                        .foregroundStyle(.colorWhite)
                    
                    Text("Sign in to continue!")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(.colorWhite)
                   
                }.padding(.bottom, 300)
                
                VStack {
                    
                    Spacer()
                    
                    VStack{
                        
                        VStack(alignment: .leading){
                            Text("E-mail/phone-number")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            
                            CustomTextField(text: $email, textInfo: "Eg. emilio.martinez@flavor", secureField: false, multiRow: false, search: false)
                                .focused($isfocused)
                            
                            Text("Password")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                                
                            
                            CustomTextField(text: $password, textInfo: "Eg. emilio.martinez@flavor", secureField: true, multiRow: false, search: false)
                                .focused($isfocused)
                            
                            HStack{
                                Spacer()
                                
                                NavigationLink(destination:
                                ForgottPassword()
                                    .environmentObject(viewModel)
                                    .navigationBarBackButtonHidden(true)
                                ){
                                    Text("Forgot password?")
                                        .font(.primaryFont(.P2))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                }
                            }
                            
                            Button(action: {
                                Task{
                                    if !email.contains("@gmail.com"){
                                        await viewModel.login(withEmail: email, password: password)
                                    } else {
                                        withAnimation(.spring(duration: 0.2, bounce: 0.4)){
                                            showShouldSignInWithGoogle.toggle()
                                        }
                                    }
                                  
                                }
                            }){
                                Text("login")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.colorWhite)
                                    .frame(height: 53)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.black)
                                    )
                                    
                            }.padding(.top, 8)
                            
                            Button(action: {
                                Task{
                                    try await viewModel.signInGoogle()
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
                                } 
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6))
                                    )
                               
                                
                            }.padding(.top, 8)
                            
                            HStack{
                                Spacer()
                                NavigationLink(destination: 
                                                MainRegistrationView(authService: viewModel.authService)
                                    .environmentObject(viewModel)
                                ){
                                    Text("Don't have an acount?")
                                        .font(.primaryFont(.P1))
                                    +
                                    
                                    Text(" Sign up")
                                        .font(.primaryFont(.P1))
                                        .fontWeight(.semibold)
                                }.foregroundStyle(.black)
                                Spacer()
                            }.padding(.top, 8)
                            
                            
                                
                        }.padding(.horizontal)
                            .padding(.top, 8)
                    }
                       .padding()
                        .background(
                        Rectangle()
                            .fill(.colorWhite)
                            .roundedCorner(16, corners: [.topLeft, .topRight])
                            
                        )
                    .frame(maxWidth: UIScreen.main.bounds.width)
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .offset(y: paddingBottom)
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture{
                    UIApplication.shared.endEditing()
                }
            .ignoresSafeArea(.all)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                            showBackground = true
                    }
            }
                .onChange(of: isfocused){
                    if isfocused {
                        withAnimation{
                            paddingBottom = -190
                        }
                    } else {
                        withAnimation{
                            paddingBottom = 0
                        }
                        
                    }
                }
                .customAlert(isPresented: $showShouldSignInWithGoogle, message: "you are trying to sign in with a google account, please user google sign in to procede", confirmAction: {
                    Task{
                        try await viewModel.signInGoogle()
                    }
                }, cancelAction: {}, dismissText: "Cacel", acceptText: "Sign in")
        }
    }
}

#Preview {
    LoginView(authservice: AuthService())
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
