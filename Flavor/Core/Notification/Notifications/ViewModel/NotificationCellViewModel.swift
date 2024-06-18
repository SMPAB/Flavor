//
//  NotificationCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import Firebase

class NotificationcellViewModel: ObservableObject {
    @Published var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    @MainActor
    func updateSeen() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("notifications")
                .document(notification.id)
                .updateData(["read": true])
        } catch {
            print("Failed to update seen status: \(error.localizedDescription)")
            throw error
        }
    }
}
