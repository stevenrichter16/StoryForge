//
//  CharacterTemplate.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import Foundation

// MARK: - Character Template Model
struct CharacterTemplate: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let genre: Genre
    let archetype: CharacterArchetype
    let complexity: ComplexityLevel
}
