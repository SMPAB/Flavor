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
    @Published var fetchingChallenges = false

    
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
    
    @Published var dontShowResults = false
    //MARK: FORUM
    
    @Published var forumPosts: [Forum] = []
    @Published var latestForumFetch: DocumentSnapshot?
    @Published var fetchingForum = false
    
    @Published var showNewAnnouncement = false
    
    private var landingVM: LandingCrewViewModel
    
    init(crew: Crew, landingVM: LandingCrewViewModel) {
        self.crew = crew
        self.name = crew.crewName
        self.originalUids = crew.uids
        self.originalUsers = crew.userRating
        self.landingVM = landingVM
        
    }
    
    func fetchChallenges() async throws {
        do {
            self.fetchingChallenges = true
            let (challenges, newRating) = try await CrewService.fetchChallenges(crewId: crew.id)
            self.challenges = challenges
            
            // Update crew's userRating if there's newRating
            if let newRating = newRating {
                updateCrewUserRating(with: newRating)
                
                if !ratingUsers.isEmpty {
                   // try await fetchRatingUsers()
                }
            }
            self.fetchingChallenges = false
        } catch {
            self.fetchingChallenges = false
            print("Error fetching challenges: \(error.localizedDescription)")
        }
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
            
            //MARK: FORUM
            let forumRef = FirebaseConstants.CrewCollection.document(crew.id).collection("forum").document()
            let forum = Forum(id: forumRef.documentID, type: .newChallenge, timestamp: Timestamp(date: Date()), challengeID: challengeRef.documentID)
            
            guard let encodedForum = try? Firestore.Encoder().encode(forum) else { return }
            
            try await forumRef.setData(encodedForum)
            
            var forumForDisplay = forum
            forumForDisplay.challenge = challenge
            forumPosts.insert(forumForDisplay, at: 0)
            
            try await NotificationsManager.shared.uploadNewChallengeNotification(crew: crew)
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
    
    private func updateCrewUserRating(with newRating: [String: UserRating]) {
        guard var currentRating = crew.userRating else {
            crew.userRating = newRating
            return
        }
        
        // Merge newRating into currentRating
        for (userId, rating) in newRating {
            if var existingRating = currentRating[userId] {
                // Update points and wins
                existingRating.points = rating.points
                existingRating.wins.append(contentsOf: rating.wins)
                currentRating[userId] = existingRating
            } else {
                // Add new user rating
                currentRating[userId] = rating
            }
        }
        
        // Update crew's userRating
        crew.userRating = currentRating
        
        // Optionally update ratingUsers or any other UI-related data
        // Example: updateRatingUsers()
    }

    
}

//MARK: - FORUM

extension MainCrewViewModel {
    func fetchForums() async throws {
        fetchingForum = true
        let (newForums, latestsnapshot) = try await CrewService.fetchForum(crew: crew, latestDocument: latestForumFetch)
        
        for i in 0..<newForums.count {
            if !forumPosts.contains(where: {$0.id == newForums[i].id}) {
                forumPosts.append(newForums[i])
            }
        }
        latestForumFetch = latestsnapshot
        fetchingForum = false
    }
    
    func newAnnouncement(text: String, currentUser: User, voting: Bool) async throws {
        do {
            
            if voting {
                let forumRef = FirebaseConstants.CrewCollection.document(crew.id).collection("forum").document()
                
                var forum = Forum(id: forumRef.documentID, type: .voting, timestamp: Timestamp(date: Date()), Upvotes: 0, DownVotes: 0, announcementText: text, announcementTextOwnerId: currentUser.id)
                
                
                
                guard let encodedForum = try? Firestore.Encoder().encode(forum) else { return }
                
                try await forumRef.setData(encodedForum)
                
                var forumForDisplay = forum
                forum.user = currentUser
                
                forumPosts.insert(forum, at: 0)
                
                try await NotificationsManager.shared.uploadNewVotingNotification(crew: crew)
            } else {
                let forumRef = FirebaseConstants.CrewCollection.document(crew.id).collection("forum").document()
                
                var forum = Forum(id: forumRef.documentID, type: .Announcement, timestamp: Timestamp(date: Date()), announcementText: text, announcementTextOwnerId: currentUser.id)
                
                guard let encodedForum = try? Firestore.Encoder().encode(forum) else { return }
                
                try await forumRef.setData(encodedForum)
                
                var forumForDisplay = forum
                forum.user = currentUser
                
                forumPosts.insert(forum, at: 0)
                try await NotificationsManager.shared.uploadNewAnnouncmentNotification(crew: crew)
            }
           
        } catch {
            return
        }
    }
    
    func registeredUserSeenResults() async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            dontShowResults = true
           
            let challengesR = challenges.filter({($0.showFinishToUserIds ?? []).contains(uid)})
            for i in 0..<challengesR.count {
                let challenge = challengesR[i]
                let _ = try await FirebaseConstants
                    .ChallengeCollection
                    .document(challenge.id)
                    .setData([
                                    "showFinishToUserIds": FieldValue.arrayRemove([uid])
                                ], merge: true)
                
                
            }
        } catch {
            return
        }
    }
}



