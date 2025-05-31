//
//  CharacterService.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import Foundation
import SwiftData

@MainActor
final class CharacterService: ObservableObject {
    private let dataManager: DataManager
    @Published var isGenerating: Bool = false
    @Published var generationError: String?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Main Generation Method (Updated)
    func generateCharacterWithUserData(
        request: CharacterRequest,
        characterData: CharacterCreationData
    ) async throws -> CharacterProfile {
        isGenerating = true
        generationError = nil
        defer { isGenerating = false }
        
        // Build prompt that respects user input
        let systemPrompt = buildImprovedSystemPrompt(characterData: characterData)
        let userPrompt = buildImprovedUserPrompt(from: request, characterData: characterData)
        
        do {
            // Call OpenAI
            let generatedContent = try await OpenAIClient.shared.chatCompletion(
                systemPrompt: systemPrompt,
                userPrompt: userPrompt,
                temperature: request.complexityLevel.temperature
            )
            
            // Create profile with user data taking priority
            let profile = CharacterProfile(
                requestId: request.id,
                name: characterData.name, // Use user's name directly
                age: characterData.age.isEmpty ? nil : Int(characterData.age),
                occupation: characterData.occupation.isEmpty ? "Unknown" : characterData.occupation,
                tagline: "", // Will be filled from AI
                physicalDescription: "",
                personalityTraits: characterData.getPersonalityTraits(),
                backstory: ""
            )
            
            // Fill in AI-generated content
            fillProfileFromAI(profile: profile, content: generatedContent)
            
            // Save ALL selected traits
            saveAllTraits(to: profile, from: characterData)
            
            // Save the profile
            try dataManager.save(profile: profile)
            
            print("✅ Character created with user data preserved")
            print("   Name: \(profile.name)")
            print("   Age: \(profile.age ?? 0)")
            print("   Occupation: \(profile.occupation)")
            print("   All traits saved: \(profile.allTraitNames.count) traits in \(profile.allSelectedTraits.count) categories")
            
            return profile
        } catch {
            generationError = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Legacy Generation Method (for backward compatibility)
    func generateCharacter(request: CharacterRequest) async throws -> CharacterProfile {
        isGenerating = true
        generationError = nil
        defer { isGenerating = false }
        
        // Store user-selected personality traits
        let userSelectedPersonalityTraits = request.additionalTraits.filter { trait in
            // Check if this trait is from Core Personality category
            CharacterTraitDatabase.categories
                .first { $0.name == "Core Personality" }?
                .traits
                .contains { $0.name == trait } ?? false
        }
        
        print("User selected personality traits: \(userSelectedPersonalityTraits)")
        
        // Build the prompt with structured output request
        let systemPrompt = buildLegacySystemPrompt(personalityTraits: userSelectedPersonalityTraits)
        let userPrompt = buildPrompt(from: request)
        
        do {
            // Call OpenAI
            let generatedContent = try await OpenAIClient.shared.chatCompletion(
                systemPrompt: systemPrompt,
                userPrompt: userPrompt,
                temperature: request.complexityLevel.temperature
            )
            
            // Parse the response into a CharacterProfile
            let profile = try parseCharacterProfile(
                from: generatedContent,
                requestId: request.id
            )
            
            // Ensure user-selected personality traits are included
            var finalPersonalityTraits = Set(profile.personalityTraits)
            finalPersonalityTraits.formUnion(userSelectedPersonalityTraits)
            profile.personalityTraits = Array(finalPersonalityTraits)
            
            // Save the profile
            try dataManager.save(profile: profile)
            
            print("✅ Character profile created with traits: \(profile.personalityTraits)")
            
            return profile
        } catch {
            generationError = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Helper Methods
    private func saveAllTraits(to profile: CharacterProfile, from characterData: CharacterCreationData) {
        // Convert trait objects to string arrays by category
        var traitsByCategory: [String: [String]] = [:]
        
        for (category, traits) in characterData.traits {
            if !traits.isEmpty {
                traitsByCategory[category] = traits.map { $0.name }
            }
        }
        
        profile.allSelectedTraits = traitsByCategory
        
        // Also ensure personality traits are set correctly
        if let personalityTraits = traitsByCategory["Core Personality"] {
            profile.personalityTraits = personalityTraits
        }
    }
    
    private func buildImprovedSystemPrompt(characterData: CharacterCreationData) -> String {
        return """
        You are a master storyteller. Create rich character details to complement the provided information.
        
        IMPORTANT CONSTRAINTS:
        - Character name is already set: \(characterData.name)
        - Age is \(characterData.age.isEmpty ? "to be determined by you" : "already set: \(characterData.age)")
        - Occupation is \(characterData.occupation.isEmpty ? "to be determined by you" : "already set: \(characterData.occupation)")
        - Character MUST embody these traits: \(characterData.getAllTraitNames().joined(separator: ", "))
        
        Generate ONLY the following sections:
        
        [TAGLINE]
        (A compelling one-line description that captures their essence)
        
        [APPEARANCE]
        (Physical description that reflects their traits and background)
        
        [DISTINGUISHING_FEATURES]
        - Feature 1
        - Feature 2
        (List 2-4 unique physical features)
        
        [CORE_BELIEF]
        (One sentence describing their fundamental belief based on their traits)
        
        [BACKSTORY]
        (2-3 paragraphs explaining how they developed these traits)
        
        [KEY_LIFE_EVENTS]
        - Event 1
        - Event 2
        - Event 3
        (List 3-5 events that shaped their selected traits)
        
        [FEARS]
        - Fear 1
        - Fear 2
        (List 2-3 fears that contrast with their traits)
        
        [DESIRES]
        - Desire 1
        - Desire 2
        (List 2-3 desires aligned with their traits)
        
        [SECRETS]
        - Secret 1
        (1-2 secrets that add depth)
        
        [MOTIVATIONS]
        - Motivation 1
        - Motivation 2
        (Based on their core motivation trait)
        
        [INTERNAL_CONFLICT]
        (How their traits create internal tension)
        
        [EXTERNAL_CONFLICT]
        (What challenges their traits create in the world)
        
        [CHARACTER_ARC]
        (How they might grow beyond their current traits)
        """
    }
    
    private func buildImprovedUserPrompt(from request: CharacterRequest, characterData: CharacterCreationData) -> String {
        var prompt = "Create a detailed character profile for \(characterData.name)"
        
        // Add basic info
        if !characterData.occupation.isEmpty {
            prompt += ", a \(characterData.occupation)"
        }
        if !characterData.age.isEmpty {
            prompt += ", age \(characterData.age)"
        }
        
        // Add genre and archetype
        prompt += " in a \(request.genre.name) setting. They are a \(request.archetype.name) character."
        prompt += "\n\nWorld Elements: \(request.genre.worldElements.joined(separator: ", "))"
        
        // Add all traits organized by category
        var traitsByCategory: [String] = []
        for category in CharacterTraitDatabase.categories {
            if let categoryTraits = characterData.traits[category.name], !categoryTraits.isEmpty {
                let traitNames = categoryTraits.map { $0.name }.joined(separator: ", ")
                traitsByCategory.append("\(category.name): \(traitNames)")
            }
        }
        
        if !traitsByCategory.isEmpty {
            prompt += "\n\nCharacter traits:\n" + traitsByCategory.joined(separator: "\n")
        }
        
        // Add additional notes
        if !characterData.additionalNotes.isEmpty {
            prompt += "\n\nAdditional context: \(characterData.additionalNotes)"
        }
        
        prompt += "\n\nComplexity Level: \(request.complexityLevel.name) - \(request.complexityLevel.complexityDescription)"
        
        return prompt
    }
    
    private func buildLegacySystemPrompt(personalityTraits: [String]) -> String {
        return """
        You are a master storyteller and character creator. Create rich, complex characters with depth and nuance.
        
        IMPORTANT: The character MUST have these personality traits: \(personalityTraits.joined(separator: ", "))
        
        Format your response EXACTLY as follows, with each section clearly labeled:
        
        [NAME]
        (Character's full name)
        
        [AGE]
        (Numeric age)
        
        [OCCUPATION]
        (Character's profession or role)
        
        [TAGLINE]
        (A compelling one-line description)
        
        [APPEARANCE]
        (Physical description paragraph)
        
        [DISTINGUISHING_FEATURES]
        - Feature 1
        - Feature 2
        (List 2-4 unique physical features)
        
        [PERSONALITY_TRAITS]
        - MUST INCLUDE: \(personalityTraits.joined(separator: "\n- MUST INCLUDE: "))
        - Additional trait 1
        - Additional trait 2
        (Include the required traits above plus 1-2 additional complementary traits)
        
        [CORE_BELIEF]
        (One sentence describing their fundamental belief)
        
        [BACKSTORY]
        (2-3 paragraph backstory)
        
        [KEY_LIFE_EVENTS]
        - Event 1
        - Event 2
        - Event 3
        (List 3-5 major life events)
        
        [FEARS]
        - Fear 1
        - Fear 2
        (List 2-3 deep fears)
        
        [DESIRES]
        - Desire 1
        - Desire 2
        (List 2-3 core desires)
        
        [SECRETS]
        - Secret 1
        - Secret 2
        (List 1-2 hidden secrets)
        
        [MOTIVATIONS]
        - Motivation 1
        - Motivation 2
        (List 2-3 driving motivations)
        
        [INTERNAL_CONFLICT]
        (One paragraph describing internal struggle)
        
        [EXTERNAL_CONFLICT]
        (One paragraph describing external challenges)
        
        [CHARACTER_ARC]
        (One paragraph describing potential character growth)
        """
    }
    
    private func buildPrompt(from request: CharacterRequest) -> String {
        var prompt = "\(request.archetype.prompt)\(request.userPrompt)"
        prompt += "\n\nGenre: \(request.genre.name)"
        prompt += "\nWorld Elements: \(request.genre.worldElements.joined(separator: ", "))"
        
        if let ageRange = request.ageRange {
            prompt += "\nAge Range: \(ageRange)"
        }
        
        if let timePeriod = request.timePeriod {
            prompt += "\nTime Period: \(timePeriod)"
        }
        
        if !request.additionalTraits.isEmpty {
            prompt += "\nAdditional Traits: \(request.additionalTraits.joined(separator: ", "))"
        }
        
        prompt += "\n\nComplexity Level: \(request.complexityLevel.name) - \(request.complexityLevel.complexityDescription)"
        
        return prompt
    }
    
    private func fillProfileFromAI(profile: CharacterProfile, content: String) {
        // Only fill in what the AI should generate
        profile.tagline = extractSection(from: content, section: "TAGLINE") ?? "A complex character"
        profile.physicalDescription = extractSection(from: content, section: "APPEARANCE") ?? ""
        profile.distinguishingFeatures = extractList(from: content, section: "DISTINGUISHING_FEATURES")
        profile.coreBelief = extractSection(from: content, section: "CORE_BELIEF") ?? ""
        profile.backstory = extractSection(from: content, section: "BACKSTORY") ?? ""
        profile.keyLifeEvents = extractList(from: content, section: "KEY_LIFE_EVENTS")
        profile.fears = extractList(from: content, section: "FEARS")
        profile.desires = extractList(from: content, section: "DESIRES")
        profile.secrets = extractList(from: content, section: "SECRETS")
        profile.motivations = extractList(from: content, section: "MOTIVATIONS")
        profile.internalConflict = extractSection(from: content, section: "INTERNAL_CONFLICT") ?? ""
        profile.externalConflict = extractSection(from: content, section: "EXTERNAL_CONFLICT") ?? ""
        profile.characterArc = extractSection(from: content, section: "CHARACTER_ARC") ?? ""
        
        // If user didn't provide age/occupation, try to extract from AI
        if profile.age == nil {
            if let ageString = extractSection(from: content, section: "AGE"),
               let parsedAge = Int(ageString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                profile.age = parsedAge
            }
        }
        
        if profile.occupation == "Unknown" || profile.occupation.isEmpty {
            if let occupation = extractSection(from: content, section: "OCCUPATION") {
                profile.occupation = occupation
            }
        }
    }
    
    private func parseCharacterProfile(from content: String, requestId: String) throws -> CharacterProfile {
        let name = extractSection(from: content, section: "NAME") ?? "Unknown Character"
        let occupation = extractSection(from: content, section: "OCCUPATION") ?? "Unknown"
        let tagline = extractSection(from: content, section: "TAGLINE") ?? "A mysterious character"
        
        // Parse optional age
        var age: Int? = nil
        if let ageString = extractSection(from: content, section: "AGE"),
           let parsedAge = Int(ageString.trimmingCharacters(in: .whitespacesAndNewlines)) {
            age = parsedAge
        }
        
        // Create profile with required parameters
        let profile = CharacterProfile(
            requestId: requestId,
            name: name,
            age: age,
            occupation: occupation,
            tagline: tagline,
            physicalDescription: extractSection(from: content, section: "APPEARANCE") ?? "",
            personalityTraits: extractList(from: content, section: "PERSONALITY_TRAITS"),
            backstory: extractSection(from: content, section: "BACKSTORY") ?? ""
        )
        
        profile.occupation = extractSection(from: content, section: "OCCUPATION") ?? "Unknown"
        profile.tagline = extractSection(from: content, section: "TAGLINE") ?? "A mysterious character"
        profile.physicalDescription = extractSection(from: content, section: "APPEARANCE") ?? ""
        profile.distinguishingFeatures = extractList(from: content, section: "DISTINGUISHING_FEATURES")
        profile.personalityTraits = extractList(from: content, section: "PERSONALITY_TRAITS")
        profile.coreBelief = extractSection(from: content, section: "CORE_BELIEF") ?? ""
        profile.backstory = extractSection(from: content, section: "BACKSTORY") ?? ""
        profile.keyLifeEvents = extractList(from: content, section: "KEY_LIFE_EVENTS")
        profile.fears = extractList(from: content, section: "FEARS")
        profile.desires = extractList(from: content, section: "DESIRES")
        profile.secrets = extractList(from: content, section: "SECRETS")
        profile.motivations = extractList(from: content, section: "MOTIVATIONS")
        profile.internalConflict = extractSection(from: content, section: "INTERNAL_CONFLICT") ?? ""
        profile.externalConflict = extractSection(from: content, section: "EXTERNAL_CONFLICT") ?? ""
        profile.characterArc = extractSection(from: content, section: "CHARACTER_ARC") ?? ""
        
        return profile
    }
    
    private func extractSection(from content: String, section: String) -> String? {
        let pattern = "\\[\(section)\\]\\s*\\n([^\\[]+)"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let range = NSRange(location: 0, length: content.utf16.count)
        guard let match = regex.firstMatch(in: content, range: range) else {
            return nil
        }
        
        guard let textRange = Range(match.range(at: 1), in: content) else {
            return nil
        }
        
        return String(content[textRange]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func extractList(from content: String, section: String) -> [String] {
        guard let sectionContent = extractSection(from: content, section: section) else {
            return []
        }
        
        let items = sectionContent
            .components(separatedBy: "\n")
            .compactMap { line -> String? in
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.hasPrefix("-") {
                    return String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces)
                } else if trimmed.hasPrefix("•") {
                    return String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces)
                } else if !trimmed.isEmpty && trimmed.count > 2 {
                    return trimmed
                }
                return nil
            }
        
        return items
    }
}
