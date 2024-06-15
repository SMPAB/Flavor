//
//  StoryService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import Foundation
import Firebase

class StoryService {
    
    static func fetchStoryUsers(userFollowingBacth: [String]) async throws -> [User]{
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        var last2Days: [String] = []

        for i in 0..<2 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                last2Days.append(dateFormatter.string(from: date))
            }
        }
        
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .whereField("userName", in: userFollowingBacth)
                .whereField("latestStory", in: last2Days)
                .getDocuments()
            
            var users = snapshot.documents.compactMap({try? $0.data(as: User.self)})
            
            for i in 0..<users.count{
                let user = users[i]
                users[i].seenStory = try await checkIfCurrentUserHasSeenUserstory(user: user)
            }
            return users
        } catch {
            return []
        }
    }
    
    static func checkIfCurrentUserHasSeenUserstory(user: User) async throws -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(user.id)
                .collection("seen-story")
                .document("batch1")
                .getDocument()
            
            if let data = snapshot.data(), let seenIds = data["userIds"] as? [String] {
                        return seenIds.contains(currentUid)
                    } else {
                        // If there's no data or no "userIds" field, assume the story hasn't been seen
                        return false
                    }
        } catch {
            return false
        }
    }
    
    static func fetchStory(userId: String) async throws -> [Story] {
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
        var last2Days: [String] = []

        for i in 0..<2 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                last2Days.append(dateFormatter.string(from: date))
            }
        }
        
        do {
            let snapshot = try await FirebaseConstants
                .StoryCollection
                .whereField("timestampDate", in: last2Days)
                .whereField("ownerUid", isEqualTo: userId)
                .getDocuments()
            
            var storys = snapshot.documents.compactMap({ try? $0.data(as: Story.self)})
            return storys
        } catch {
            return []
        }
    }
    
    static func fetchStorysForDate(userId: String, dateString: String) async throws -> [Story] {
        do {
            print("DEBUG APP USERID: \(userId) DATESTRING: -\(dateString)-")
            let snapshot = try await FirebaseConstants
                .StoryCollection
                .whereField("ownerUid", isEqualTo: userId)
                .whereField("timestampDate", isEqualTo: dateString)
                .getDocuments()
            
            print("DEBUG APP SNAPSHOT COUNT \(snapshot.count)")
            var storys = snapshot.documents.compactMap({ try? $0.data(as: Story.self)})
            return storys
        } catch {
            return []
        }
    }
    
    static func fetchCalenderStoryDays(_ userId: String) async throws -> [String]{
        
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(userId)
                .collection("story-days")
                .document("batch1")
                .getDocument()
            
            if let data = snapshot.data(), let days = data["storyDays"] as? [String] {
                        return days
                    } else {
                        return []
                    }
        } catch {
            return []
        }
    }
    
    
}
