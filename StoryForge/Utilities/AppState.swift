//
//  AppState.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

@MainActor
class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var activeFilter: Genre? = nil
    @Published var isCreatingCharacter: Bool = false
    @Published var characterCreationProgress: Double = 0.0
    
    func navigateToTab(_ tab: Int) {
        selectedTab = tab
    }
    
    func setFilter(_ genre: Genre?) {
        activeFilter = genre
    }
    
    func startCharacterCreation() {
        isCreatingCharacter = true
        characterCreationProgress = 0.0
    }
    
    func updateCreationProgress(_ progress: Double) {
        characterCreationProgress = progress
    }
    
    func finishCharacterCreation() {
        isCreatingCharacter = false
        characterCreationProgress = 1.0
    }
}
