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
    
    var users: [String]
    var completedUsers: [String]
}
