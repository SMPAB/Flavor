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
    
    @Published var currentlyPinnedPost: String?
    
    //@Published var storys = [Story]()
    
    @Published var userFollowingUsernames = [String]()
    @Published var fetchedFollowingUsernames = false
    @Published var recomendedUsers: [User] = []
    
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
    
    
    //QR CODE
    @Published var whatWasSaved = ""
    @Published var QRuserName = ""
    @Published var showQRCode = false
    @Published var QRCODELINK = ""
    
    //UPLOAD
    @Published var showCamera = false
    
    
    //NAMESPACE
    
    @Published var selectedStory: Story?
    @Published var showSelectedStory = false
    
    @Published var selectedChallengePost: ChallengeUpload?
    
    
    //NAVGATIONS
    @Published var navigationUser: User?
    @Published var navigateToUser = false
    
    
    
    //LOCAL UPDATES
    @Published var newPosts: [Post] = []
    @Published var newStorys: [Story] = []
    
    @Published var newPinPost: String?
    @Published var newUnpinPost: String?
    
    @Published var newChallengePosts: [ChallengeUpload] = []
    @Published var newPublicChallengePosts: [ChallengeUpload] = []
    
    @Published var newUploadPublicChallenge = false
    @Published var newDeletePublicChallenge = false
    @Published var newVotePublicChallenge = false
    @Published var newunVotePublicChallenge = false
    
    
    
    
    //Edit
    @Published var showEditPost = false
    @Published var editPost: Post? = Post.mockPosts[0]
    @Published var newUrls: [String] = []
    @Published var newTitle = ""
    @Published var newDescription = ""
    
    @Published var newEditPost: Post?
    
    //DELETE
    @Published var deletePost: Post?
    @Published var showDeletePostAlert = false
    @Published var deletedPost: String?
    
    @Published var deleteStory: Story?
    @Published var showDeleteStoryAlert = false
    @Published var deletedStorys: [String] = []
    
    
    
    init(user: User) {
        self.user = user
        self.currentlyPinnedPost = user.pinnedPostId
    }
    
    @MainActor
    func fetchFollowingUsernames() async throws {
        self.userFollowingUsernames = try await UserService.fetchUserFollowingUsernames(id: user.id)
        fetchedFollowingUsernames = true
        print("Debug app userFollowing usernames: \(userFollowingUsernames)")
    }
    
    
}

//MARK: - Feed
extension HomeViewModel {
    
    
    
    
    @MainActor
    func fetchRecomendedUsers() async throws {
        do {
            self.recomendedUsers = try await UserService.fetchRecomendedUsers()
        } catch {
            return
        }
    }
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
        
        guard !userFollowingUsernames.isEmpty else {
            try await fetchStoryUsersNoFollowing()
            return
        }
        
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
        
        for i in 0..<allUsers.count{
            if !storyUsers.contains(allUsers[i]){
                storyUsers.append(allUsers[i])
            }
        }
        
        self.storyUsers.sort { $0.isCurrentUser && !$1.isCurrentUser }
    }
    
    @MainActor
    func fetchStoryUsersNoFollowing() async throws {
        
        let usernames = [user.userName]
        
        do {
            let newUsers = try await StoryService.fetchStoryUsers(userFollowingBacth: usernames)
            
            for i in 0..<newUsers.count {
                if !storyUsers.contains(newUsers[i]){
                    storyUsers.append(newUsers[i])
                }
            }
            
            
        } catch {
            fetchingPosts = false
            return
        }
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

//MARK: - DELETE
extension HomeViewModel {
    @MainActor
    func deletePost() async throws {
        do {
            if let post = deletePost {
                
                
                if currentlyPinnedPost == post.id {
                    try await PostService.unpin(postId: post.id)
                }
                
                try await PostService.deletePost(post)
                deletedPost = post.id
            }
            
        } catch {
            return
        }
    }
    
    func deleteStory() async throws {
        do {
            if let story = deleteStory {
                
                try await PostService.deleteStory(story)
                deletedStorys.append(story.id)
                
            }
            
        } catch {
            return
        }
    }
}

//MARK: - REPORT

extension HomeViewModel {
    func reportStory(_ story: Story, text: String) async throws {
        do {
            var data: [String:Any] = [
                "StoryId": story.id,
                "OwnerUid": story.ownerUid,
                "text": text,
                "timestamp": Timestamp(date: Date())
                
            ]
            
            try await FirebaseConstants.ReportsCollection.document("posts").collection("storys").document().setData(data)
        } catch {
            return
        }
    }
    
   
}


