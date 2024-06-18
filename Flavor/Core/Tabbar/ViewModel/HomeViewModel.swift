//
//  HomeViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import Firebase

class HomeViewModel: ObservableObject{
    @Published var user: User

    //STORYS
    @Published var currentUserHasStory = false
    @Published var storyUsers: [User] = []
    @Published var selectedStoryUser: String = ""
    @Published var showStory: Bool = false
    @Published var fetchinStory = false
    
    //@Published var storys = [Story]()
    
    @Published var userFollowingUsernames = [String]()
    
    @Published var fetchedUsers = [String]()
    

    @Published var seenPosts = [String]()
    @Published var posts = [Post]()
    private var latestFeedFetch: DocumentSnapshot?
    @Published var fetchingPosts = false
    
    //VARIABLEVIEW
    @Published var showVariableView = false
    @Published var variablesTitle: String = ""
    @Published var variableSubTitle: String?
    @Published var variableUplaods: [Post] = []
    @Published var selectedVariableUploadId: String?

    
    //Focus post
    @Published var focusPostIndex: Int? 
    @Published var focusPost: Post?
    @Published var showFocusPost = false
    
    //NOTIFICATIONS
    @Published var userHasNotification = false
        //FRIEND REQUESRTS
    @Published var friendRequestUsernames: [String] = []
    
    
    //UPLOAD
    @Published var showCamera = false
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    func fetchFollowingUsernames() async throws {
        self.userFollowingUsernames = try await UserService.fetchUserFollowingUsernames(id: user.id)
        print("Debug app userFollowing usernames: \(userFollowingUsernames)")
    }
    
    
}

//MARK: - Feed
extension HomeViewModel {
    @MainActor
    func fetchFeedPosts() async throws {
        
        
        guard !userFollowingUsernames.isEmpty else { return }
        
        // Split userFollowingUsernames into chunks of up to 30 elements
        let chunks = userFollowingUsernames.chunked(into: 30)
        
        // Initialize variables to accumulate posts and track the last snapshot
        var allPosts: [Post] = []
        var lastSnapshot: DocumentSnapshot?
        
        // Iterate over each chunk and fetch posts
        for chunk in chunks {
            do {
                let (newPosts, chunkLastSnapshot) = try await PostService.fetchFeedPosts(userFollowingUsernames: chunk, seenPosts: seenPosts, lastDocument: lastSnapshot)
                
                // Append fetched posts to allPosts array
                allPosts.append(contentsOf: newPosts)
                
                // Update lastSnapshot with the last document snapshot from this chunk
                lastSnapshot = chunkLastSnapshot
                
                fetchingPosts = false
            } catch {
                print("Error fetching posts for chunk: \(chunk)")
                
                fetchingPosts = false
            }
        }
        
        // Update posts array with all fetched posts
        self.posts.append(contentsOf: allPosts)
        
        // Update latestFeedFetch with the last snapshot from the last chunk
        self.latestFeedFetch = lastSnapshot
    }
}

//MARK: - Story
extension HomeViewModel {
    
    @MainActor
    func fetchStorysForUser() async throws{
        
            guard !fetchedUsers.contains(selectedStoryUser) else { return }
            
       
        
        
            let storiesForSelectedUser = try await StoryService.fetchStory(userId: selectedStoryUser)
            
            if let index = storyUsers.firstIndex(where: { $0.id == selectedStoryUser}){
                storyUsers[index].storys = storiesForSelectedUser
            }
            
            fetchedUsers.append(selectedStoryUser)
        
            fetchinStory = false
        
            
    }
    
    @MainActor
    func fetchStoryUsers() async throws{
        
        guard !userFollowingUsernames.isEmpty else { return }
        
        // Split userFollowingUsernames into chunks of up to 30 elements
        var allUserNamesToFetch = userFollowingUsernames
        allUserNamesToFetch.append(user.userName)
        let chunks = allUserNamesToFetch.chunked(into: 30)
        
        // Initialize variables to accumulate posts and track the last snapshot
        var allUsers: [User] = []
        
        // Iterate over each chunk and fetch posts
        for chunk in chunks {
            do {
                let newUsers = try await StoryService.fetchStoryUsers(userFollowingBacth: chunk)
                
                // Append fetched posts to allPosts array
                allUsers.append(contentsOf: newUsers)
                
                
                fetchingPosts = false
            } catch {
                fetchingPosts = false
            }
        }
        
        // Update posts array with all fetched posts
        self.storyUsers.append(contentsOf: allUsers)
        
        self.storyUsers.sort { $0.isCurrentUser && !$1.isCurrentUser }
    }
    
    @MainActor
    func storySeen() async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        if let index = storyUsers.firstIndex(where: {$0.id == selectedStoryUser}){
            storyUsers[index].seenStory = true
        }
        
        //print("DEBUG APP USERID: \(userId)")
        let batch1DocRef =  FirebaseConstants
            .UserCollection
                    .document(selectedStoryUser)
                    .collection("seen-story")
                    .document("batch1")
                    //.document(currentUid)
                    //.setData([:])
                    
        
        try await batch1DocRef.setData([
                   "userIds": FieldValue.arrayUnion([currentUid])
               ], merge: true)
        
    }
    
    @MainActor
    func chechIfCurrentUserSeenStory()  {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        var last2Days: [String] = []

        for i in 0..<2 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                last2Days.append(dateFormatter.string(from: date))
            }
        }
    
        print("DEBUG APP LATEST STORY DAYS: \(last2Days)")
        if let latestStory = user.latestStory{
            self.currentUserHasStory = last2Days.contains(latestStory)
        }
        
        print("DEBUG APP HASSTORY: \(currentUserHasStory)")
       
    }
}
//MARK: - NOTIFICATIONS

extension HomeViewModel {
    @MainActor
    func fetchFriendRequests() async throws {
        self.friendRequestUsernames = try await UserService.fetchFriendRequestUsernames()
    }
    
    @MainActor
    func checkIfUserHasANotification() async throws {
        self.userHasNotification = try await NotificationService.fetchOneNotification()
    }
}
