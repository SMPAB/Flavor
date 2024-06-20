//
//  ratingUser.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import Foundation

struct ratingUser: Identifiable, Hashable, Codable {
    let user: User
    var rating: Double
    var id: String {
        return user.id
    }
}
