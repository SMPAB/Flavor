//
//  LandingCrewViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import Foundation
import Firebase

class LandingCrewViewModel: ObservableObject {
    @Published var crews: [Crew] = []
    @Published var fetchingCrews = false
    private var latestCrewSnapshot: DocumentSnapshot?
    
    func fetchCrews() async throws {
        do {
            fetchingCrews = true
            let (newCrews, latestSnapshot) = try await CrewService.fetchUserCrews(latestSnapshot: latestCrewSnapshot)
            for i in 0..<newCrews.count {
                if !crews.contains(newCrews[i]) {
                    crews.append(newCrews[i])
                }
            }
            latestCrewSnapshot = latestSnapshot
            fetchingCrews = false
        } catch {
            fetchingCrews = false
            return
        }
    }
}
