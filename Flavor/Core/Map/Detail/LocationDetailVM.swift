//
//  LocationDetailVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-25.
//

import Foundation
import MapKit

class LocationDetailVM: ObservableObject {
    @Published var selectedLocation: MKMapItem
    @Published var mapVM: MapViewModel
    @Published var location: Location?
    @Published var firstStory: Story?
    
    
    @Published var showPosts = false
    //@Published var selectedPost: String?
    
    @Published var selectedPost: Post?
    
    @Published var fetchedPosts = [Post]()
    
    init(selectedLocation: MKMapItem, mapVM: MapViewModel) {
        self.selectedLocation = selectedLocation
        self.mapVM = mapVM
    }
    
    
    func fetchLocation() async throws {
        
        do {
            self.location = try await MapService.fetchLocation(id: getIdentifier(for: selectedLocation))
            if let location = location {
                try await fetchFirstStory()
            }
            print("DEBUG APP LOCATION: \(location)")
        } catch {
            return
        }
        
    }
    
    func getIdentifier(for mapItem: MKMapItem) -> String {
        let latitude = mapItem.placemark.coordinate.latitude
        let longitude = mapItem.placemark.coordinate.longitude
        // Create a unique identifier based on coordinates and name
        var identifier: String =  "\(latitude)\(longitude)".replacingOccurrences(of: ".", with: "")
        return identifier
    }
    
    func fetchFirstStory() async throws {
        if let firstStoryId = location?.storyIds?.first {
            self.firstStory = try await StoryService.fetchStoryWithId(firstStoryId)
        }
    }
    
    
}
