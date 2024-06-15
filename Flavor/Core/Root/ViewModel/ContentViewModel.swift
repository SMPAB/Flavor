//
//  ContentViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import Firebase
import Combine

@MainActor
class ContentViewModel: ObservableObject{
    private let service: AuthService
    private var cancellables = Set<AnyCancellable>()
    @Published var userSession: FirebaseAuth.User?
    
    init(service: AuthService){
        self.service = service
        setupSubscribers()
    }
    
     func setupSubscribers() {
        service.$userSession.sink { [ weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
    }
}
