//
//  SceneController.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-02.
//

import Foundation
import SwiftUI

class SceneController: ObservableObject {
    @Published var hideOverlay = true {
        didSet {
            // If we have a delegate, we can call methods on it
            if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                delegate.updateOverlayVisibility(hideOverlay)
            }
        }
    }
    
    
    @Published var selectedPost: Post?
    @Published var storyIds = [String]()
    
    @Published var showPost = false
    @Published var showStorys = false
}
