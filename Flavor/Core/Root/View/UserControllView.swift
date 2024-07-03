//
//  UserControllView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct UserControllView: View {
    
    @StateObject var viewModel = UserControllViewModel()
    @EnvironmentObject var contentViewModel: ContentViewModel
    var authservice: AuthService
    
    var body: some View {
        
        ZStack{
            
            Color.colorOrange
            if let user = viewModel.user {
                Tabview(user: user, authService: authservice)
                    .environmentObject(contentViewModel)
            } else if viewModel.user == nil && viewModel.hasFetchedUser {
                Text("Set upp account")
            } else {
                ZStack{
                    
                    Color.colorOrange
                    Image("GradientStill")
                        .scaleEffect(1.3)
                
                    VStack{
                        Image("Logo_Single_White")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 110)
                        
                        Text("Savor the Flavor")
                            .font(.primaryFont(.H4))
                            .foregroundStyle(.colorWhite)
                            .opacity(0)
                        
                       
                    }
                }
            }
        }.background(.colorOrange)
        
    }
}

#Preview {
    UserControllView(authservice: AuthService())
}
