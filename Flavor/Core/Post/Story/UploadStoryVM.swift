//
//  UploadStoryVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-18.
//

import Foundation
import Firebase

class UploadStoryVM: ObservableObject {
    @Published var image: FilteredImage?
    
    @Published var title = ""
    
    
    @Published var allChallenges: [Challenge] = []
    @Published var challenge: Challenge?
    
    
    init(image: FilteredImage? = nil) {
        self.image = image
    }

    func uploadStory(user: User, homeVM: HomeViewModel) async throws {
        
        guard image != nil else { return }
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        let todayString = dateFormatter.string(from: Date())
        
        do {
            //MARK: STORY
            let storyRef = FirebaseConstants.StoryCollection.document()
            let storyId = storyRef.documentID
            
            var challengeUploadId = FirebaseConstants.ChallengeUploadCollection.document()
            if let challenge = challenge {
                challengeUploadId = FirebaseConstants.ChallengeCollection.document(challenge.id).collection("posts").document()
            }
            
            var IMAGEURL: String?
            
            
            var story = Story(id: storyId, ownerUid: user.id, imageUrl: nil, postID: nil, challengeUploadId: challenge != nil ? challengeUploadId.documentID : nil, timestamp: Timestamp(date: Date()), timestampDate: todayString, title: title)
            
            if let imageUrl = try await ImageUploader.uploadImage(image: image!.image){
                story.imageUrl = imageUrl
                IMAGEURL = imageUrl
            }
            
            guard let encodedStory = try? Firestore.Encoder().encode(story) else { return }
            try await storyRef.setData(encodedStory)
            
            //MARK: USER
            var userData = [String:Any]()
            userData["latestStory"] = todayString
            try await FirebaseConstants.UserCollection.document(user.id).updateData(userData)
            
            let uploadDates = try await StoryService.fetchCalenderStoryDays(user.id)
            if !uploadDates.contains(todayString){
                let docRef = FirebaseConstants.UserCollection.document(user.id).collection("story-days").document("batch1")
                
                try await docRef.setData([
                           "storyDays": FieldValue.arrayUnion([todayString])
                       ], merge: true)
            }
            
            let seenStoryRef = FirebaseConstants
                .UserCollection
                .document(user.id)
                .collection("seen-story")
                .document("batch1")
            
            try await seenStoryRef.updateData([
                   "userIds": []
               ])
            
            
            //MARK: CHALLENGE
            if let challenge = challenge {
                let challengeUpload = ChallengeUpload(id: challengeUploadId.documentID,
                                                      challengeId: challenge.id,
                                                      ownerUid: user.id,
                                                      storyId: storyId,
                                                      imageUrl: IMAGEURL,
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
            
            //MARK: LOCAL CHANGES
            var localStory = story
            homeVM.currentUserHasStory = true
            
            if let index = homeVM.storyUsers.firstIndex(where: { $0.id == user.id }) {
                homeVM.storyUsers[index].storys?.insert(localStory, at: 0)
                
                
            } else {
                var localUser = user
                localUser.storys?.append(localStory)
                homeVM.storyUsers.insert(localUser, at: 0)
                
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
