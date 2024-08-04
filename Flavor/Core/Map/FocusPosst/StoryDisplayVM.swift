//
//  StoryDisplayVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-03.
//

import SwiftUI

class StoryDisplayVM: ObservableObject {
    @Published var storyId: String
    @Published var story: Story?
    @Published var fetchingStory = false
    
    init(storyId: String) {
        self.storyId = storyId
    }
    
    func fetchStory() async throws {
        do {
            fetchingStory = true
            self.story = try await StoryService.fetchStoryWithId(storyId)
            fetchingStory = false
        } catch {
            return
        }
        
    }
}
