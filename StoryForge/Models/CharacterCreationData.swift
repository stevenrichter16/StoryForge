//
//  CharacterCreationData.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

// MARK: - Data Model
struct CharacterCreationData {
    let name: String
    let age: String
    let occupation: String
    let genre: Genre
    let archetype: CharacterArchetype
    let complexity: ComplexityLevel
    let traits: [String: Set<CharacterTrait>]
    let additionalNotes: String
    
    // Convert to prompt for AI
    func buildPrompt() -> String {
        var prompt = "Create a character named \(name)"
        
        if !age.isEmpty {
            prompt += ", age \(age)"
        }
        
        if !occupation.isEmpty {
            prompt += ", who works as a \(occupation)"
        }
        
        prompt += " in a \(genre.name) setting. They are a \(archetype.name) character."
        
        // Add traits
        var traitDescriptions: [String] = []
        for (category, traits) in traits where !traits.isEmpty {
            let traitNames = traits.map { $0.name }.joined(separator: ", ")
            traitDescriptions.append("\(category): \(traitNames)")
        }
        
        if !traitDescriptions.isEmpty {
            prompt += "\n\nCharacter traits:\n" + traitDescriptions.joined(separator: "\n")
        }
        
        if !additionalNotes.isEmpty {
            prompt += "\n\nAdditional details: \(additionalNotes)"
        }
        
        return prompt
    }
}
