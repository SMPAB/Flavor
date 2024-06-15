//
//  ProfileViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    @Published var showEditProfile = false
    
    @Published var grid = true
    @Published var album = false
    @Published var calender = false
    @Published var saved = false
    
    @Published var userFollowing: [String] = []
    @Published var userFollowers: [String] = []
    
    
    //MARK: EDIT
    //@Published var userName = ""
    @Published var caption = ""
    @Published var imageurl = ""
    @Published var PublicAccount = false
   
    @Published var image: Image?
    @Published var uiImage: UIImage?
    @Published var showImageView = false
    
    //MARK: SAVED
    @Published var savedPosts: [Post] = []
    @Published var savedPostSnapshot: DocumentSnapshot?
    @Published var fetchingSavedPosts = false
    
    //MARK: GRID
    @Published var posts: [Post] = []
    private var lastPostFetched: String?
    @Published var fetchingGridPosts = false
    
    //MARK: CALENDER
    @Published var fetchedCalenderDays: [String] = []
    @Published var calenderStorys: [Story] = []
    @Published var userStoryDats: [String] = []
    
    //MARK: ALBUM
    
    
    init(user: User) {
        self.user = user
        self.imageurl = user.profileImageUrl ?? ""
        self.caption = user.biography ?? ""
        self.PublicAccount = user.publicAccount
    }
}

//MARK: STATISTICS
extension ProfileViewModel {
    func fetchUserStats() async throws {
        self.user.stats = try await UserService.fetchUserStats(user.id)
    }
    
    func fetchUserFollowingFollowersStats() async throws {
        self.userFollowers = try await UserService.fetchUserFollowersUsernames(id: user.id)
        self.userFollowing = try await UserService.fetchUserFollowingUsernames(id: user.id)
        
        var stats = UserStats(followingCount: 0, followersCount: 0, flavorCount: 0)
        stats.followersCount = userFollowers.count
        stats.followingCount = userFollowing.count
        self.user.stats = stats
    }
}

//MARK: EDIT PROFILE
extension ProfileViewModel {
    func updateUserData() async throws {
        
        var data = [String:Any]()
        
        if let uiImage = uiImage{
               let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
                data["profileImageUrl"] = imageUrl
            user.profileImageUrl = imageUrl
            
        }
        if PublicAccount != user.publicAccount {
            data["publicAccount"] = PublicAccount
            user.publicAccount = PublicAccount
        }
        
        if caption != user.biography {
            user.biography = caption
            data["biography"] = caption
        }
        
        if !data.isEmpty{
            try await FirebaseConstants.UserCollection.document(user.id).updateData(data)
        }
    }
}
//MARK: - SAVED
extension ProfileViewModel {
    @MainActor
       func fetchSavedPosts() async throws {
           fetchingSavedPosts = true
           let (fetchedPosts, lastSnapshot) = try await PostService.fetchSavedPostsForUser(lastDocument: savedPostSnapshot)
           
           // Filter out duplicates
           let newPosts = fetchedPosts.filter { fetchedPost in
               !self.savedPosts.contains(where: { $0.id == fetchedPost.id })
           }
           
           self.savedPosts.append(contentsOf: newPosts)
           self.savedPostSnapshot = lastSnapshot
           fetchingSavedPosts = false
       }
}

//MARK: - GRID

extension ProfileViewModel {
    func fetchGridPosts() async throws {
        fetchingGridPosts = true
        let (fetchedPosts, lastPostId) = try await PostService.fetchGridPosts(user, lastPostFetch: lastPostFetched)
        
        let newPosts = fetchedPosts.filter { fetchedPost in
            !self.posts.contains(where: { $0.id == fetchedPost.id})
        }
        
        self.posts.append(contentsOf: newPosts)
        self.lastPostFetched = lastPostId
        fetchingGridPosts = false
    }
}

//MARK: - CALENDER

extension ProfileViewModel{
    func fetchStorysForDate(date: Date) async throws {
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        
        let dateString = dateFormatter.string(from: date)
        
        print("DEBUG APP DATESTRING: \(dateString)")
        
        guard !fetchedCalenderDays.contains(dateString) else { return }
        
        let newStorys = try await StoryService.fetchStorysForDate(userId: user.id, dateString: dateString)
        
        calenderStorys.append(contentsOf: newStorys)
        fetchedCalenderDays.append(dateString)
    }
    
    func fetchCalenderStoryDays() async throws {
        self.userStoryDats = try await StoryService.fetchCalenderStoryDays(user.id)
    }
}
