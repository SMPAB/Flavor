//
//  MainCrewViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import Foundation
import SwiftUI
import Firebase

@MainActor
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
    
    //CREATE CHALLENGE
    @Published var challengeImage: Image?
    @Published var challengeUiImage: UIImage?
    
    @Published var challengeTitle = ""
    @Published var challengeDescription = ""
    @Published var challengeStart = Date()
    @Published var challengeEnd = Date()
    
    
    @Published var ratingUsers: [UserRating] = []
    
    private var landingVM: LandingCrewViewModel
    
    init(crew: Crew, landingVM: LandingCrewViewModel) {
        self.crew = crew
        self.name = crew.crewName
        self.originalUids = crew.uids
        self.originalUsers = crew.userRating
        self.landingVM = landingVM
        
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
            if let index = landingVM.crews.firstIndex(where: {$0.id == crew.id}){
                landingVM.crews[index].imageUrl = imageUrl
            }
        }
        
        //CHANGE IN USERNAME
        if name != crew.crewName && name != ""{
            crew.crewName = name
            data["crewName"] = name
            if let index = landingVM.crews.firstIndex(where: {$0.id == crew.id}){
                landingVM.crews[index].crewName = name
            }
        }
        
        // CHANGE IN SELECTED USERS
        var updatedUserRating = crew.userRating ?? [:]
        var updatedUids = selectedUser.map({$0.id})
                
                // Add new users to userRating and uids
                for user in selectedUser {
                    if updatedUserRating[user.id] == nil {
                        updatedUserRating[user.id] = UserRating(id: user.id, points: 0, wins: [])
                    }
                    /*if !updatedUids.contains(user.id) {
                        updatedUids.append(user.id)
                    }*/
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
        
        
        if let index = landingVM.crews.firstIndex(where: {$0.id == crew.id}){
            landingVM.crews[index].uids = updatedUids
            landingVM.crews[index].userRating = updatedUserRating
        }
        selectedUser = []
    }
    
    
    func createChallenge() async throws {
        do {
            let challengeRef = FirebaseConstants.ChallengeCollection.document()
            
            var challenge = Challenge(id: challengeRef.documentID, crewId: crew.id, title: challengeTitle, description: challengeDescription, imageUrl: nil, startDate: Timestamp(date: challengeStart), endDate: Timestamp(date: challengeEnd), votes: 1, finished: false, users: crew.uids, completedUsers: [])
            
            if let image = challengeUiImage {
                let imageUrl = try await ImageUploader.uploadImage(image: image)
                challenge.imageUrl = imageUrl
            }
            
            
            guard let encodedChallenge = try? Firestore.Encoder().encode(challenge) else { return }
            try await challengeRef.setData(encodedChallenge)
            
            let challengeForDisplay = Challenge(id: challengeRef.documentID, crewId: crew.id, title: challengeTitle, description: challengeDescription, imageUrl: challenge.imageUrl, startDate: Timestamp(date: challengeStart), endDate: Timestamp(date: challengeEnd), votes: 1, finished: false, users: crew.uids, completedUsers: [], crew: crew)
            
            challenges.append(challengeForDisplay)
        } catch {
            return
        }
    }
    
    func fetchRatingUsers() async throws {
            guard let userRatingDict = crew.userRating else { return }
            var userRatings = Array(userRatingDict.values).sorted { $0.points > $1.points }
            
            for i in 0..<userRatings.count {
                let user = try await UserService.fetchUser(withUid: userRatings[i].id)
                userRatings[i].user = user
            }
            
            self.ratingUsers = userRatings
        }
    
    
}
