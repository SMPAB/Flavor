//
//  NotificationType.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

enum NotificationsType: Int, Codable {
    case like
    case comment
    case follow
    
    var notidicationMessage: String {
        switch self {
        case .like: return " has liked your flavor."
        case .follow: return " started following you."
        case .comment: return " commented on one of your posts."
        }
    }
}
