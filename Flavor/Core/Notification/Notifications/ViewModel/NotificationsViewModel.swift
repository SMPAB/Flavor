//
//  NotificationsViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import Firebase

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    private var latestDocument: DocumentSnapshot?
    @Published var fetchingNotifications = false
    @Published var initialFetched = false
    
    @MainActor
    func fetchNotifications() async throws {
        fetchingNotifications = true
        let (newNotifications, lastDocument) = try await NotificationService.fetchNotifications(latestFetch: latestDocument)
        for i in 0..<newNotifications.count {
            if !notifications.contains(where: {$0.id == newNotifications[i].id}){
                notifications.append(newNotifications[i])
            }
        }
        latestDocument = lastDocument
        fetchingNotifications = false
        initialFetched = true
    }
}
