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
            
           // try await uploadUserData(withEmail: email, id: result.user.uid, birthday: birthday, userName: userName, biography: biography, phoneNumber: "", publicAccount: publicAccount, profileImageUrl: profileImage)
            try await createAccount(username: userName)
        } catch {
            print("DEBUG APP: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createAccount(username: String) async throws -> User?{
        guard let currentUid = Auth.auth().currentUser?.uid else { return nil}
        
        do {
            var user = User(id: currentUid,
                            email: "",
                            userName: username,
                            publicAccount: false)
            
            if let email = Auth.auth().currentUser?.email {
                user.email = email
            }
            
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return nil}
            try await FirebaseConstants.UserCollection.document(currentUid).setData(encodedUser)
            
            try await FirebaseConstants.userNameCollection.document("batch1").setData(["usernames": FieldValue.arrayUnion([username])], merge: true)
            return user
        } catch {
            return nil
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
            
           // try await uploadUserData(withEmail: "", id: id, birthday: birthday, userName: userName, biography: biography, phoneNumber: "", publicAccount: publicAccount, profileImageUrl: profileImage)
            
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
