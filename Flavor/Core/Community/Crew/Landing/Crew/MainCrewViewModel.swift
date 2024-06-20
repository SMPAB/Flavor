//
//  MainCrewViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import Foundation

class MainCrewViewModel: ObservableObject {
    
    @Published var crew: Crew
    
    @Published var challenges: [Challenge] = []
    
    init(crew: Crew) {
        self.crew = crew
    }
    
    func fetchChallenges() async throws {
        self.challenges = try await CrewService.fetchChallenges(crewId: crew.id)
    }
}
