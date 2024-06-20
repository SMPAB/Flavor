//
//  PostService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation
import Firebase

class PostService {
    
    static func fetchPost(_ postId: String) async throws -> Post? {
            do {
                let document = try await FirebaseConstants.PostCollection.document(postId).getDocument()
                var post = try document.data(as: Post.self)
                
                post.user = try await UserService.fetchUser(withUid: post.ownerUid)
                return post
            } catch {
                // Handle any errors appropriately (e.g., log the error)
                print("Failed to fetch post with error: \(error)")
                return nil
            }
        }
    static func fetchFeedPosts(userFollowingUsernames: [String], seenPosts: [String], lastDocument: DocumentSnapshot? = nil) async throws -> ([Post], DocumentSnapshot?){
        
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMdd"
                var last7Days: [String] = []
        //MARK: THIS IS LAST 60 DAYS!!!
        for i in 0..<60 {
                    if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                        last7Days.append(dateFormatter.string(from: date))
                    }
                }
        
        do {
            var query: Query = FirebaseConstants
                .PostCollection
                .whereField("ownerUsername", in: userFollowingUsernames)
               // .whereField("timestampDate", in: ["May11", "May03", "May02", "May01", "Jun", "Jul", "Sept", "Oktober", "Nov", "Hello", "d", "please", "Work", "you", "peace", "of","shit", "hello", "Cmor", "Please", "messi", "p", "pac", "bacs", "kasd", "deqe", "21372", "hdasd", "dashdad", "haeads", "dasdasdm"])
                .limit(to: 10)
            
            
            
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
           
            var posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self)})
            
            
            for i in 0..<posts.count{
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            posts = posts.filter { !seenPosts.contains($0.id)}
            let lastSnapshot = snapshot.documents.last
            
            return (posts,lastDocument)
        } catch {
            return ([], lastDocument)
        }
        
        
    }
}
//MARK: LIKE SAVE
extension PostService{
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).collection("post-likes").document(uid).setData([:])
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).updateData(["likes": post.likes + 1])
        async let _ = FirebaseConstants.UserCollection.document(uid).collection("user-likes").document(post.id).setData([:])
    }
    
    static func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).collection("post-likes").document(uid).delete()
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).updateData(["likes": post.likes - 1])
        async let _ = FirebaseConstants.UserCollection.document(uid).collection("user-likes").document(post.id).delete()
    }
    
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await FirebaseConstants
                .PostCollection
                .document(post.id)
                .collection("post-likes")
                .document(uid)
                .getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
        
    }
    
    static func SavePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = FirebaseConstants.UserCollection.document(uid).collection("saved-posts").document(post.id).setData([:])
    }
    
    static func unSavePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = FirebaseConstants.UserCollection.document(uid).collection("saved-posts").document(post.id).delete()
    }
    
    static func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(uid)
                .collection("saved-posts")
                .document(post.id)
                .getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
        
    }
}
//MARK: - Saved

extension PostService{
    static func fetchSavedPostsForUser(lastDocument: DocumentSnapshot? = nil) async throws -> ([Post], DocumentSnapshot?){
        guard let uid = Auth.auth().currentUser?.uid else { return ([], nil)}
        
       
        
        do {
            var query: Query = FirebaseConstants
                .UserCollection
                .document(uid)
                .collection("saved-posts")
                .limit(to: 6)
            
          
            
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            
            
            let snapshot = try await query.getDocuments()
            
            
            let postIds = snapshot.documents.map { $0.documentID }
            
            var posts: [Post] = []
            
            for i in 0..<postIds.count{
                let postId = postIds[i]
                if let post = try await PostService.fetchPost(postId){
                    posts.append(post)
                }
            }
            
            
            for i in 0..<posts.count{
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            let lastSnapshot = snapshot.documents.last
            
            
            return (posts,lastSnapshot)
        } catch {
            return ([], nil)
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//MARK: - GRID
extension PostService {
    static func fetchGridPosts(_ user: User, lastPostFetch: String?) async throws -> ([Post], String?) {

        do {
            guard let postIdArray = user.postIds else { return ([], lastPostFetch)}

            // Determine where to start fetching based on lastPostFetch
            let startIndex: Int
            if let lastFetchId = lastPostFetch, let index = postIdArray.firstIndex(of: lastFetchId) {
                startIndex = index + 1
            } else {
                startIndex = 0 // Start from the beginning if lastPostFetch is nil or not found
            }

            var fetchedPosts: [Post] = []
            var nextFetchId: String? = nil

            // Fetch 10 posts starting from startIndex
            let endIndex = min(startIndex + 10, postIdArray.count)
            for i in startIndex..<endIndex {
                let postId = postIdArray[i]

                // Assuming Firebase fetch logic (adjust this based on your actual Firebase setup)
                if let post = try await fetchPost(postId){
                    fetchedPosts.append(post)
                }
            }

            // Determine nextFetchId for pagination
            if endIndex < postIdArray.count {
                nextFetchId = postIdArray[endIndex]
            }

            return (fetchedPosts, nextFetchId)
        } catch {
            return ([], lastPostFetch)
        }
        
    }

}

//MARK: - Album

extension PostService {
    static func fetchAlbumPosts(_ album: Album, lastPostFetch: String?) async throws -> ([Post], String?) {

        let postIdArray = album.uploadIds

        // Determine where to start fetching based on lastPostFetch
        let startIndex: Int
        if let lastFetchId = lastPostFetch, let index = postIdArray.firstIndex(of: lastFetchId) {
            startIndex = index + 1
        } else {
            startIndex = 0 // Start from the beginning if lastPostFetch is nil or not found
        }

        var fetchedPosts: [Post] = []
        var nextFetchId: String? = nil

        // Fetch 10 posts starting from startIndex
        let endIndex = min(startIndex + 10, postIdArray.count)
        for i in startIndex..<endIndex {
            let postId = postIdArray[i]

            // Assuming Firebase fetch logic (adjust this based on your actual Firebase setup)
            if let post = try await fetchPost(postId){
                fetchedPosts.append(post)
            }
        }

        // Determine nextFetchId for pagination
        if endIndex < postIdArray.count {
            nextFetchId = postIdArray[endIndex]
        }

        return (fetchedPosts, nextFetchId)
    }
}

//MARK: - Search

extension PostService {
    static func fetchTrendingPosts(lastDocument: DocumentSnapshot? = nil) async throws -> ([Post], DocumentSnapshot?) {
        
        do {
            var query: Query = FirebaseConstants
                .PostCollection
                .order(by: "likes", descending: true)
                .limit(to: 7)
            
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
           
            var posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self)})
            
            
            for i in 0..<posts.count{
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            let lastSnapshot = snapshot.documents.last
            
            let filterdPosts = posts.filter({$0.user?.publicAccount == true})
            
            return (filterdPosts, lastSnapshot)
        } catch {
            return ([], lastDocument)
        }
        
    }
    
    static func fetchRecomendedPosts(lastDocument: DocumentSnapshot? = nil) async throws -> ([Post], DocumentSnapshot?) {
        
        do {
            var query: Query = FirebaseConstants
                .PostCollection
                .limit(to: 7)
                //.order(by: "likes", descending: true)
            
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
           
            var posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self)})
            
            
            for i in 0..<posts.count{
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            let filterdPosts = posts.filter({$0.user?.publicAccount == true})
            
            let lastSnapshot = snapshot.documents.last
            
            return (filterdPosts, lastSnapshot)
        } catch {
            return ([], lastDocument)
        }
        
    }
}

//MARK: - RECIPE

extension PostService {
    static func fetchRecipe(recipeId: String) async throws -> Recipe?{
        do {
            return try await FirebaseConstants.RecipeCollection.document(recipeId).getDocument().data(as: Recipe.self)
        } catch {
            return nil
        }
    }
    
    static func checkIfUserSavedRecipe(recipeId: String) async throws -> Bool {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return false}
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("saved-recipes")
                .document(recipeId)
                .getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
    }
    
    static func saveRecipe(recipeId: String) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
           async let _ = try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("saved-recipes")
                .document(recipeId)
                .setData([:])
        } catch {
            return
        }
    }
    
    static func unSaveRecipe(recipeId: String) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
           async let _ = try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("saved-recipes")
                .document(recipeId)
                .delete()
        } catch {
            return
        }
    }
    
    
    static func fetchSavedRecipesForUser(lastDocument: DocumentSnapshot? = nil) async throws -> ([Recipe], DocumentSnapshot?){
        guard let uid = Auth.auth().currentUser?.uid else { return ([], nil)}
        
       
        
        do {
            var query: Query = FirebaseConstants
                .UserCollection
                .document(uid)
                .collection("saved-recipes")
                .limit(to: 6)
            
          
            
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            
            
            let snapshot = try await query.getDocuments()
            
            
            let recipeIds = snapshot.documents.map { $0.documentID }
            
            var recipes: [Recipe] = []
            
            for i in 0..<recipeIds.count{
                let recipeId = recipeIds[i]
                if let recipe = try await PostService.fetchRecipe(recipeId: recipeId){
                    recipes.append(recipe)
                }
            }
            
            
            for i in 0..<recipes.count{
                let recipe = recipes[i]
                let ownerUid = recipe.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                recipes[i].user = user
            }
            
            let lastSnapshot = snapshot.documents.last
            
            
            return (recipes,lastSnapshot)
        } catch {
            return ([], nil)
        }
    }
}
