//
//  Notification.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import Firebase

struct Notification: Identifiable, Hashable, Codable{
    let id: String
    let postId: String?
    var timestamp: Timestamp
    let type: NotificationsType
    var userUids: [String]
    
    var read: Bool = false
    
    var post: Post?
    var users: [User]?
    
   
}
