//
//  Challenge.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import Foundation
import Firebase


struct Challenge: Identifiable, Hashable, Codable {
    let id: String
    let crewId: String
    
    var title: String
    var description: String
    var imageUrl: String?
    
    var startDate: Timestamp
    var endDate: Timestamp
    
    var votes: Int
    
    var finished: Bool? = false
    var showFinishToUserIds: [String]?
    
    var users: [String]
    var completedUsers: [String]
    
    var crew: Crew?
}

extension Challenge {
    static var mockChallenges: [Challenge] {
        return [
            .init(id: "001", crewId: "002", title: "Taco", description: "Gör din bästa taco", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), votes: 3, users: [], completedUsers: [])
        ]
    }
}
