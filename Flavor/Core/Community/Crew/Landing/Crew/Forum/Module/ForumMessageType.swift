//
//  ForumMessageType.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-30.
//

import Foundation

enum ForumType: Int, Codable {
    case newChallenge
    case newMember
    case voting
    
    /*var notidicationMessage: String {
        switch self {
        case .like: return " has liked your flavor."
        case .follow: return " started following you."
        case .comment: return " commented on one of your posts."
        }
    }*/
}
