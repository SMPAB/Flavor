//
//  PublicChallenge.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import Foundation
import Firebase

struct PublicChallenge: Identifiable, Hashable, Codable {
    let id: String
    
    let ownerName: String
    let ownerImageUrl: String?
    
    let title: String
    let description: String
    let imageUrl: String?
    
    let startDate: Timestamp
    let endDate: Timestamp
    
    let votes: Int
    
    let prizes: [prize]?
    
    var userDoneVoting: Bool? = false
    var userHasPublished: Bool? = false
    
}

struct prize: Hashable, Codable {
    let place: Int
    let prizeName: String
    let prizeDescription: String
    let prizeImageUrl: String?
    let prizeWorth: Double?
}


extension PublicChallenge {
    static var mockChallenges: [PublicChallenge] {
        return [
            .init(id: "001", ownerName: "Global", ownerImageUrl: nil, title: "Slice and Dice", description: "Publish the best slicing challenge you possibly can!", imageUrl: nil, startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), votes: 3, prizes: [prize(place: 1, prizeName: "Knive", prizeDescription: "en vacker kniv från global", prizeImageUrl: nil, prizeWorth: 999.99)])
        ]
    }
}
