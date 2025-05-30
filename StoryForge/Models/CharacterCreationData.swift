//
//  CharacterCreationData.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

// CharacterCreationData.swift
import Foundation

struct CharacterCreationData {
    let name: String
    let age: String
    let occupation: String
    let genre: Genre
    let archetype: CharacterArchetype
    let complexity: ComplexityLevel
    let traits: [String: Set<CharacterTrait>]
    let additionalNotes: String
    
    // Debug helper
    func debugPrintTraits() {
        print("=== Character Creation Data Debug ===")
        print("Name: \(name)")
        print("Traits by category:")
        for (category, categoryTraits) in traits {
            if !categoryTraits.isEmpty {
                print("  \(category): \(categoryTraits.map { $0.name }.joined(separator: ", "))")
            }
        }
        print("===================================")
    }
    
    // Convert to prompt for AI with better trait handling
    func buildPrompt() -> String {
        var prompt = "Create a character named \(name)"
        
        if !age.isEmpty {
            prompt += ", age \(age)"
        }
        
        if !occupation.isEmpty {
            prompt += ", who works as a \(occupation)"
        }
        
        prompt += " in a \(genre.name) setting. They are a \(archetype.name) character."
        
        // Add traits with better formatting
        var traitsByCategory: [String] = []
        
        for category in CharacterTraitDatabase.categories {
            if let categoryTraits = traits[category.name], !categoryTraits.isEmpty {
                let traitNames = categoryTraits.map { $0.name }.joined(separator: ", ")
                traitsByCategory.append("\(category.name): \(traitNames)")
            }
        }
        
        if !traitsByCategory.isEmpty {
            prompt += "\n\nCharacter traits by category:\n" + traitsByCategory.joined(separator: "\n")
        }
        
        // Specifically call out personality traits for the AI
        if let personalityTraits = traits["Core Personality"], !personalityTraits.isEmpty {
            let personalityList = personalityTraits.map { $0.name }.joined(separator: ", ")
            prompt += "\n\nIMPORTANT: The character's core personality traits MUST include: \(personalityList)"
        }
        
        if !additionalNotes.isEmpty {
            prompt += "\n\nAdditional details: \(additionalNotes)"
        }
        
        return prompt
    }
    
    // Helper to get all trait names as a flat array
    func getAllTraitNames() -> [String] {
        var allTraitNames: [String] = []
        for (_, categoryTraits) in traits {
            allTraitNames.append(contentsOf: categoryTraits.map { $0.name })
        }
        return allTraitNames
    }
    
    // Helper to get personality traits specifically
    func getPersonalityTraits() -> [String] {
        return traits["Core Personality"]?.map { $0.name } ?? []
    }
}
