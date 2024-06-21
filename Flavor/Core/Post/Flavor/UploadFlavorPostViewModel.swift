//
//  UploadFlavorPostViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import SwiftUI
import Firebase

class UploadFlavorPostViewModel: ObservableObject {
    @Published var title = ""
    @Published var caption = ""
    
    
    @Published var recipe = false
    
    @Published var allChallenges: [Challenge] = []
    @Published var challenge: Challenge?

    @Published var recipeTitle = ""
    @Published var recipeDiff: Int?
    @Published var recipeTime: String?
    @Published var recipeServings: Int?
    @Published var recipeIng: [ingrediences] = []
    @Published var recipeSteps: [steps] = []
    @Published var recipeUtt: [utensil] = []
    
    
    func combineIngredientsAndUtensils() {
           recipeIng = recipeSteps.flatMap { (step: steps) -> [ingrediences] in
               step.ingrediences
           }
        recipeUtt = Array(Set(recipeSteps.compactMap { (step: steps) -> utensil in
               step.utensils
           }))
       }
    
    
    func uploadFlavorPostViewModel(images: [UIImage], user: User) async throws {
    
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        let todayString = dateFormatter.string(from: Date())
       
        do {
            //MARK: POST
            let postId = FirebaseConstants.PostCollection.document()
            let storyId = FirebaseConstants.StoryCollection.document()
            let recipeId = Firestore.firestore().collection("recipe").document()
            let challengeUploadId = FirebaseConstants.ChallengeCollection.document(challenge?.id ?? "").collection("posts").document()
            
            var post = Post(id: postId.documentID, ownerUid: user.id, ownerUsername: user.userName, likes: 0, title: title, caption: caption, imageUrls: nil, storyID: storyId.documentID, recipeId: recipe ? recipeId.documentID : nil, challengeUploadId: challenge != nil ? challengeUploadId.documentID : nil, timestamp: Timestamp(date: Date()), timestampDate: todayString, hasLiked: nil, hasSaved: nil, user: nil)
            
            var imageUrls: [String] = []
            
            for i in 0..<images.count {
                if let imageUrl = try await ImageUploader.uploadImage(image: images[i]){
                    imageUrls.append(imageUrl)
                }
            }
            post.imageUrls = imageUrls
            
            if recipe{
                post.storyID = storyId.documentID
            }
            
            //MARK: STORY
            
            var story = Story(id: storyId.documentID, ownerUid: user.id, imageUrl: imageUrls[0], postID: postId.documentID, challengeUploadId: challenge != nil ? challengeUploadId.documentID : nil, timestamp: Timestamp(date: Date()), timestampDate: todayString, title: title)
            
            guard let encodedPost = try? Firestore.Encoder().encode(post) else { return }
            guard let encodedStory = try? Firestore.Encoder().encode(story) else { return }
            
            try await postId.setData(encodedPost)
            try await storyId.setData(encodedStory)
            
            //MARK: UPDATE USER
            //update postIds and latest story
            var postsIds = user.postIds
            postsIds?.insert(postId.documentID, at: 0)
            var userData = [String:Any]()
            userData["postIds"] = postsIds
            userData["latestStory"] = todayString
            try await FirebaseConstants.UserCollection.document(user.id).updateData(userData)
            
            //add date to uploaddays
            let uploadDates = try await StoryService.fetchCalenderStoryDays(user.id)
            if !uploadDates.contains(todayString){
                let docRef = FirebaseConstants.UserCollection.document(user.id).collection("story-days").document("batch1")
                
                try await docRef.setData([
                           "storyDays": FieldValue.arrayUnion([todayString])
                       ], merge: true)
            }
            //Remove users that have seen story
            let seenStoryRef = FirebaseConstants
                .UserCollection
                .document(user.id)
                .collection("seen-story")
                .document("batch1")
            
            try await seenStoryRef.updateData([
                   "userIds": []
               ])
            
            //MARK: RECIPE
            if recipe{
                let recipe = Recipe(id: recipeId.documentID,
                                    ownerUid: user.id,
                                    publicRecipe: user.publicAccount,
                                    ownerPost: postId.documentID,
                                    name: recipeTitle,
                                    difficualty: recipeDiff ?? 3,
                                    time: recipeTime ?? "20-30min",
                                    servings: recipeServings ?? 4,
                                    ingrediences: recipeIng,
                                    steps: recipeSteps,
                                    utensils: recipeUtt,
                                    imageUrl: imageUrls[0]
                )
                
                guard let encodedRecipe = try? Firestore.Encoder().encode(recipe) else { return }
                try await recipeId.setData(encodedRecipe)
            }
            
            //MARK: CHALLENGE
            if let challenge = challenge {
                let challengeUpload = ChallengeUpload(id: challengeUploadId.documentID,
                                                      challengeId: challenge.id,
                                                      ownerUid: user.id,
                                                      storyId: storyId.documentID,
                                                      postId: postId.documentID,
                                                      imageUrl: imageUrls[0],
                                                      timestamp: Timestamp(date: Date()),
                                                      title: title,
                                                      votes: 0)
                
                guard let encodedChallengePost = try? Firestore.Encoder().encode(challengeUpload) else { return }
                try await challengeUploadId.setData(encodedChallengePost)
                
                let docRef = FirebaseConstants.ChallengeCollection.document(challenge.id)
                
                try await docRef.setData([
                    "completedUsers": FieldValue.arrayUnion([user.id])
                       ], merge: true)
            }
            
        } catch {
            return
        }
    }
    
    func fetchAllChallenges() async throws {
        do {
            self.allChallenges = try await CrewService.fetchUserChallenges()
        } catch {
            return
        }
    }
}
