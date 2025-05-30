//
//  CharacterTraitCategory.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import Foundation

// Comprehensive trait system for character creation
struct CharacterTraitCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
    let traits: [CharacterTrait]
    let allowsMultiple: Bool
    let isRequired: Bool
}

