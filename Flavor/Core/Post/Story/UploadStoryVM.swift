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
    
    
    init(image: FilteredImage? = nil) {
        self.image = image
    }
    
    func uploadStory(user: User) async throws {
        
        guard image != nil else { return }
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        let todayString = dateFormatter.string(from: Date())
        
        do {
            //MARK: STORY
            let storyRef = FirebaseConstants.StoryCollection.document()
            let storyId = storyRef.documentID
            
            
            var story = Story(id: storyId, ownerUid: user.id, imageUrl: nil, postID: nil, challengeUploadId: nil, timestamp: Timestamp(date: Date()), timestampDate: todayString, title: title)
            
            if let imageUrl = try await ImageUploader.uploadImage(image: image!.image){
                story.imageUrl = imageUrl
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
        } catch {
            return
        }
    }
}
