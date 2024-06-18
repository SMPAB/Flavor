//
//  Story.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import Foundation
import Firebase

struct Story: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    
    var imageUrl: String?
    let postID: String?
    let challengeUploadId: String?
    
    let timestamp: Timestamp
    let timestampDate: String
    let title: String
}

extension Story {
    static var mockStorys: [Story] {
        return [
            .init(id: "001", ownerUid: "osadsa", imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/favoorswiftui.appspot.com/o/profile_images%2F440C3648-5044-4C03-9327-438D8BB5A09B?alt=media&token=4f9d4b25-035a-4d8d-8b15-9281659a0d78", postID: "nil", challengeUploadId: nil, timestamp: Timestamp(date: Date()), timestampDate: "Jun14", title: "Najs wook today!")
        ]
    }
}
