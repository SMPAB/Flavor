//
//  MainAuthView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct MainAuthView: View {
    @State var showLanding = true
    
    var authService: AuthService
    var body: some View {
        ZStack{
            LoginView(authservice: authService)
            
            if showLanding{
                LandingView(showLanding: $showLanding)
            }
        }
    }
}

#Preview {
    MainAuthView(authService: AuthService())
}
