//
//  AuthService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-11.
//

import Foundation

import Foundation
import Firebase
import SwiftUI

@MainActor
class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    @Published var fromPhone = false
    @Published var registerPhoneUser = false
    
    static let shared = AuthService()
    
    init(){
        self.userSession = Auth.auth().currentUser
    }
    
    func updateUserSession() async throws {
        self.userSession = Auth.auth().currentUser
    }
    
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            
        }
    }
    
    func loginWithNumber(CODE: String, verificationCode: String){
        
        self.fromPhone = true
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: CODE, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (result, err) in
            if let error = err {
                // self.errorMsg = error.localizedDescription
                // self.error.toggle()
                return
            }
            self.userSession = result?.user
            
        }
    }
    
    func createUserWithEmail(withEmail email: String,
                    password: String,
                    birthday: Timestamp?,
                    userName: String,
                    biography: String?,
                    phoneNumber: String?,
                    publicAccount: Bool,
                    profileImage: String?
    ) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            try await uploadUserData(withEmail: email, id: result.user.uid, birthday: birthday, userName: userName, biography: biography, phoneNumber: "", publicAccount: publicAccount, profileImageUrl: profileImage)
        } catch {
            print("DEBUG APP: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUserWithPhoneNumber(id: String,
                    birthday: Timestamp?,
                    userName: String,
                    biography: String?,
                    phoneNumber: String?,
                    publicAccount: Bool,
                    profileImage: String?
    ) async throws {
        do {
            
            try await uploadUserData(withEmail: "", id: id, birthday: birthday, userName: userName, biography: biography, phoneNumber: "", publicAccount: publicAccount, profileImageUrl: profileImage)
            
            fromPhone = false
            
        } catch {
            print("DEBUG APP: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    
    
    func signout(){
        try? Auth.auth().signOut()
        self.userSession = nil
    }
    
    private func uploadUserData(withEmail email: String,
                                id: String,
                                birthday: Timestamp?,
                                userName: String,
                                biography: String?,
                                phoneNumber: String?,
                                publicAccount: Bool,
                                profileImageUrl: String?) async throws {
        
       /// let user = User(id: id, email: email, phoneNumber: phoneNumber, userName: userName, publicAccount: publicAccount, profileImageUrl: profileImageUrl, birthday: birthday, biography: biography)
       /// try await UserService().uploadUserData(user)
    }
    
    //MARK: GOOGLE
    @MainActor
    func signInWithGoogle(credential: AuthCredential)  {
        
        self.fromPhone = true
        
        Auth.auth().signIn(with: credential) { (result, err) in
            if let error = err {
                // self.errorMsg = error.localizedDescription
                // self.error.toggle()
                return
            }
            self.userSession = result?.user
            
        }
    }
    
 
}
