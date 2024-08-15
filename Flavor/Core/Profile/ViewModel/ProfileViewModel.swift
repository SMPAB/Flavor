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
    
    @Published var postIds: [String]
    
    
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
    
    @Published var savedRecipes: [Recipe] = []
    @Published var savedRecipesSnapshot: DocumentSnapshot?
    @Published var fetchingSavedRecipes = false
    
    //MARK: GRID
    @Published var posts: [Post] = []
    private var lastPostFetched: String?
    @Published var fetchingGridPosts = false
    
    //MARK: CALENDER
    @Published var fetchedCalenderDays: [String] = []
    @Published var calenderStorys: [Story] = []
    @Published var userStoryDats: [String] = []
    
    //MARK: ALBUM
    @Published var albums: [Album] = []
    private var latestAlbumSnapshot: DocumentSnapshot?
    @Published var loadingAlbums = false
    @Published var hasLoadedAlbum = false
    
    @Published var showCreateAlbum = false
    
        //GRID
    @Published var albumPosts: [Post] = []
    
    //MARK: OPTIONS FOR NOT CURRENT USER
    @Published var showOptions = false
    @Published var showBlock = false
    @Published var showReport = false
    
    
    
    init(user: User) {
        self.user = user
        self.imageurl = user.profileImageUrl ?? ""
        self.caption = user.biography ?? ""
        self.PublicAccount = user.publicAccount
        
        
        var postIDS = user.postIds ?? []
        if user.pinnedPostId != nil && user.pinnedPostId != "" {
            postIDS.removeAll(where: {$0 == user.pinnedPostId})
            postIDS.insert(user.pinnedPostId ?? "", at: 0)
        }
        self.postIds = postIDS
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
            
            if let postIds = user.postIds {
                for i in 0..<postIds.count {
                    let postId = postIds[i]
                    try await FirebaseConstants.PostCollection.document(postId).setData(["publicPost": PublicAccount], merge: true)
                }
            }
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
    
    @MainActor
       func fetchSavedRecipes() async throws {
           fetchingSavedRecipes = true
           let (fetchedRecipes, lastSnapshot) = try await PostService.fetchSavedRecipesForUser(lastDocument: savedRecipesSnapshot)
           
           // Filter out duplicates
           let newRecipe = fetchedRecipes.filter { fetchedRecipe in
               !self.savedRecipes.contains(where: { $0.id == fetchedRecipe.id })
           }
           
           self.savedRecipes.append(contentsOf: newRecipe)
           self.savedRecipesSnapshot = lastSnapshot
           fetchingSavedRecipes = false
       }
}

//MARK: - GRID

extension ProfileViewModel {
    func fetchGridPosts() async throws {
        fetchingGridPosts = true
        
        if posts.isEmpty{
            let mockPosts = [Post(id: "001", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: ""), Post(id: "002", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: ""), Post(id: "003", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: ""), Post(id: "004", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: ""), Post(id: "005", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: ""), Post(id: "006", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: ""), Post(id: "007", ownerUid: "", ownerUsername: "", likes: 0, storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: "")]
            
            posts.append(contentsOf: mockPosts)
        }
        
        let (fetchedPosts, lastPostId) = try await PostService.fetchGridPosts(user, lastPostFetch: lastPostFetched)
        
        let newPosts = fetchedPosts.filter { fetchedPost in
            !self.posts.contains(where: { $0.id == fetchedPost.id})
        }
        
        self.posts.append(contentsOf: newPosts)
        self.lastPostFetched = lastPostId
        fetchingGridPosts = false
        posts.removeAll(where: {$0.id == "001"})
        posts.removeAll(where: {$0.id == "002"})
        posts.removeAll(where: {$0.id == "003"})
        posts.removeAll(where: {$0.id == "004"})
        posts.removeAll(where: {$0.id == "005"})
        posts.removeAll(where: {$0.id == "006"})
        posts.removeAll(where: {$0.id == "007"})
    }
}

//MARK: - CALENDER

extension ProfileViewModel{
    func fetchStorysForDate(date: Date) async throws {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMddYY"
        
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
//MARK: - Albums

extension ProfileViewModel {
    func fetchAlbums() async throws {
        loadingAlbums = true
        let (newAlbums, latestDocument) = try await UserService.fetchUserAlbums(user, latestDocument: latestAlbumSnapshot)
        
        let filteredAlbums = newAlbums.filter { newAlbum in
                    !self.albums.contains(where: { $0.id == newAlbum.id })
                }
        
        self.albums.append(contentsOf: filteredAlbums)
        self.latestAlbumSnapshot = latestDocument
        
        loadingAlbums = false
        hasLoadedAlbum = true
    }
}

//MARK: - BLOCK REPORT
extension ProfileViewModel {
    func block(currentUser: User) async throws {
        try await UserService.blockUser(user: user, currentUser: currentUser)
    }
    
    func report(reportText: String) async throws {
        try await UserService.report(reportText: reportText, user: user)
    }
}

//MARK: - FOLLOWING

extension ProfileViewModel {
    @MainActor
     func checkIfUserIsFollowing(id: String) async throws {
        self.user.isFollowed = try await UserService.checkIfUserIsFollowing(id)
    }
    @MainActor
     func checkIfUserHasfriendRequest(id: String) async throws {
        self.user.hasFriendRequests = try await UserService.checkIfUserHasFriendRequest(id)
    }
    @MainActor
    func follow(userToFollow: User, userFollowing: User, homeVM: HomeViewModel) async throws{
        self.user.isFollowed = true
        try await UserService.follow(userToFollow: userToFollow, userFollowing: userFollowing)
        try await NotificationsManager.shared.uploadFollowNotification(toUid: userToFollow.id)
       
        if let index = homeVM.recomendedUsers.firstIndex(where: {$0.id == userToFollow.id}){
            homeVM.recomendedUsers[index].isFollowed = true
        }
    }
    @MainActor
    func unfollow(userToUnfollow: User, userUnfollowing: User, homeVM: HomeViewModel) async throws {
        self.user.isFollowed = false
        try await UserService.unfollow(userToUnfollow: userToUnfollow, userUnfollowing: userUnfollowing)
        
        if let index = homeVM.recomendedUsers.firstIndex(where: {$0.id == userToUnfollow.id}){
            homeVM.recomendedUsers[index].isFollowed = false
        }
    }
    @MainActor
    func unsendFriendRequest(userToUnFriendRequest: User, userUnfriendrequesting: User) async throws{
        self.user.hasFriendRequests = false
        try await UserService.removeFriendRequest(userToRemoveFrom: userToUnFriendRequest, userRemoving: userUnfriendrequesting)
    }
    @MainActor
    func sendFriendRequest(sendRequestTo: User, userSending: User) async throws{
        self.user.hasFriendRequests = true
        try await UserService.sendFriendRequest(userToSendFriendRequestTo: sendRequestTo, userSending: userSending)
        try await NotificationsManager.shared.uploadFriendRequestNotification(toUid: sendRequestTo.id)
    }
}

//MARK: EDIT POST
extension ProfileViewModel {
    func editPost(_ post: Post, newTitle: String, newDescription: String, newUrls: [String], homeVM: HomeViewModel) async throws {
        do {
            
            var newPost = post
            
            var data: [String:Any] = [:]
            
            if post.title != newTitle {
                data["title"] = newTitle
                newPost.title = newTitle
                
            }
            
            if post.caption != newDescription {
                data["caption"] = newDescription
                newPost.caption = newDescription
            }
            
            if post.imageUrls != newUrls {
                
                if newUrls.count > 0 {
                    data["imageUrls"] = newUrls
                    newPost.imageUrls = newUrls
                }
            }
            
            /*if let index = postIds.firstIndex(where: {$0 == post.id}){
                postIds.removeAll(where: {$0 == post.id})
                postIds.insert(newPost.id, at: index)
            }*/
            
            homeVM.newEditPost = newPost
            
            try await FirebaseConstants.PostCollection.document(post.id).updateData(data)
            
        } catch {
            return
        }
    }
    
    func checkCurrentStreak() async throws {
        self.user.currentStreak = try await UserService.checkAndUpdateUserStreak(user: user)
    }
}
