//
//  UserControllView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct UserControllView: View {
    
    @StateObject var viewModel = UserControllViewModel()
    var authservice: AuthService
    
    var body: some View {
        if let user = viewModel.user {
            Tabview(user: user, authService: authservice)
        } else if viewModel.user == nil && viewModel.hasFetchedUser {
            Text("Set upp account")
        } else {
            Text("Loading")
        }
    }
}

#Preview {
    UserControllView(authservice: AuthService())
}
