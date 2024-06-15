//
//  LoginViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-11.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import UIKit

class LoginViewModel: ObservableObject {
    @Published var authService: AuthService
    
    @Published var error: Bool = false
    @Published var errorMsg: String = ""
    
    init(authService: AuthService){
        self.authService = authService
    }
    
    func login(withEmail email: String, password: String) async {
        do {
            try await authService.login(withEmail: email, password: password)
        } catch {
            print("DEBUG APP: Did faito log in with error \(error.localizedDescription)")
            DispatchQueue.main.async {
                            self.errorMsg = error.localizedDescription
                            self.error = true
                        }
        }
    }
    
    func forgotPassword(forEmail email: String) async {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
            } catch {
                
            }
        }
    
    //MARK: GOOGLE
    
    func signInGoogle() async throws{
        
        guard let topVX = await Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVX)
        
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        await authService.signInWithGoogle(credential: credential)
    }
}



class Utilities {
    static let shared = Utilities()
    
    private init() {}
    
    func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

