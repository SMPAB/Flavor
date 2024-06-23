//
//  MainCrewViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import Foundation
import SwiftUI
import Firebase

class MainCrewViewModel: ObservableObject {
    
    @Published var crew: Crew
    
    @Published var challenges: [Challenge] = []
    
    
    //Edit
    
    @Published var image: Image?
    @Published var uiImage: UIImage?
    
    @Published var originalUids: [String]
    @Published var originalUsers: [String: UserRating]?
    
    @Published var name = ""
    @Published var selectedUser: [User] = []
    @Published var allUsernames: [String] = []
    
    init(crew: Crew) {
        self.crew = crew
        self.name = crew.crewName
        self.originalUids = crew.uids
        self.originalUsers = crew.userRating
        
    }
    
    func fetchChallenges() async throws {
        self.challenges = try await CrewService.fetchChallenges(crewId: crew.id)
    }
    
    func fetchUsersInCrew() async throws {
        for i in 0..<crew.uids.count {
            let user = try await UserService.fetchUser(withUid: crew.uids[i])
            selectedUser.append(user)
        }
    }
    
    func fetchAllUsers() async throws {
        self.allUsernames = try await UserService.fetchAllUsernamesNoLowercase()
    }
    
    func saveEditCrew() async throws {
        
        var data: [String:Any] = [:]
        
        //CHANGE IN IMAGEURL
        if let uiImage = uiImage {
            let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
            data["imageUrl"] = imageUrl
            crew.imageUrl = imageUrl
        }
        
        //CHANGE IN USERNAME
        if name != crew.crewName && name != ""{
            crew.crewName = name
            data["crewName"] = name
        }
        
        // CHANGE IN SELECTED USERS
        var updatedUserRating = crew.userRating ?? [:]
        var updatedUids = selectedUser.map({$0.id})
                
                // Add new users to userRating and uids
                for user in selectedUser {
                    if updatedUserRating[user.id] == nil {
                        updatedUserRating[user.id] = UserRating(id: user.id, points: 0, wins: [])
                    }
                    if !updatedUids.contains(user.id) {
                        updatedUids.append(user.id)
                    }
                }
                
                // Remove users not in the selectedUser list from userRating and uids
                for (userId, _) in updatedUserRating {
                    if !selectedUser.contains(where: { $0.id == userId }) {
                        updatedUserRating.removeValue(forKey: userId)
                        updatedUids.removeAll { $0 == userId }
                    }
                }
                
                // Update the userRating and uids in Firestore and locally
                data["userRating"] = updatedUserRating.mapValues { [
                    "id": $0.id,
                    "points": $0.points,
                    "wins": $0.wins
                ]}
                data["uids"] = updatedUids
                
                // Perform the update in Firestore
                let db = Firestore.firestore()
                try await db.collection("crews").document(crew.id).updateData(data)
                
                // Update the local crew object
                crew.userRating = updatedUserRating
                crew.uids = updatedUids
    }
    
    
}
