//
//  ContentView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-11.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    private var authService: AuthService
    @StateObject var viewModel: ContentViewModel
    @EnvironmentObject var sceneController: SceneController
    
    init(authService: AuthService){
        self.authService = authService
        self._viewModel = StateObject(wrappedValue: ContentViewModel(service: authService))
    }
    
    @Namespace private var namespace

    
    var body: some View {
        ZStack {
            
            Color.colorOrange
            Group{
                if viewModel.userSession == nil {
                    MainAuthView(authService: authService)
                    
                } else {
                    UserControllView(authservice: authService)
                        .environmentObject(sceneController)
                        .environment(\.namespace, namespace)
                        .environmentObject(viewModel)
                       
                }
            }
        }
    }
}

#Preview {
    ContentView(authService: AuthService())
}
