//
//  MapService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-29.
//

import Foundation

struct MapService {
    
    static func fetchLocation(id: String) async throws -> Location? {
        do {
           return try await FirebaseConstants
                .LocationCollection
                .document(id)
                .getDocument()
                .data(as: Location.self)
            
        } catch {
            return nil
        }
    }
}
