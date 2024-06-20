//
//  CreateCrewVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import Foundation
import SwiftUI
import Firebase

class CreateCrewVM: ObservableObject {
    @Published var currentUser: User
    
    @Published var image: Image?
    @Published var uiImage: UIImage?
    @Published var showImagePicker = false
    
    @Published var crewName = ""
    
    @Published var selectedUsers: [User] = []
    //@Published var allUsers: [User] = []
    @Published var allUserNames: [String] = []
    
    
    @Published var landingVM: LandingCrewViewModel
    init(currentUser: User, landingVM: LandingCrewViewModel) {
        self.currentUser = currentUser
        self.landingVM = landingVM
    }
    
    
    func fetchAllUsernames() async throws {
        var userFollowingUsernames = try await UserService.fetchUserFollowingUsernames(id: currentUser.id)
        allUserNames.append(contentsOf: userFollowingUsernames)
        
        
        let allOtherUsernames = try await UserService.fetchAllUsernamesNoLowercase()
        for i in 0..<allOtherUsernames.count {
            if !allUserNames.contains(where: {$0 == allOtherUsernames[i]}){
                self.allUserNames.append(allOtherUsernames[i])
            }
        }
    }
    
    
    func uploadCrewToCollection() async throws {
        
        var allUsers = selectedUsers
        allUsers.append(currentUser)
        do {
            let crewRef = FirebaseConstants.CrewCollection.document()
            
            
            var userRating: [String: [String: Any]] = [:]
                        for user in allUsers {
                            userRating[user.id] = [
                                "id": user.userName,
                                "points": 0,
                                "wins": []
                                /*"seconds": [],
                                "thirds": []*/
                            ]
                        }
            
            var imageUrl: String?
            
            if let uiImage = uiImage {
                imageUrl = try await ImageUploader.uploadImage(image: uiImage)
            }
            
            var data: [String:Any] = [
                "id": crewRef.documentID,
                "admin": currentUser.id,
                "imageUrl": imageUrl ?? nil,
                "creationDate": Timestamp(date: Date()),
                "crewName": crewName,
                "publicCrew": false,
                "uids": allUsers.map({$0.id}),
                "userRating": userRating
            ]
            
            try await crewRef.setData(data)
            
            let crewForDisplay = Crew(id: crewRef.documentID,
                                      admin: currentUser.id,
                                      crewName: crewName,
                                      imageUrl: imageUrl,
                                      creationDate: Timestamp(date: Date()),
                                      publicCrew: false,
                                      uids: allUsers.map({$0.id})
            )
            
            landingVM.crews.append(crewForDisplay)
        } catch {
            
        }
    }
}
