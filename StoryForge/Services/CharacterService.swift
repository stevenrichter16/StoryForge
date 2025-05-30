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
    
    func generateCharacter(request: CharacterRequest) async throws -> CharacterProfile {
        isGenerating = true
        generationError = nil
        defer { isGenerating = false }
        
        // Build the prompt with structured output request
        let systemPrompt = """
        You are a master storyteller and character creator. Create rich, complex characters with depth and nuance.
        
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
        - Trait 1
        - Trait 2
        - Trait 3
        (List 3-5 personality traits)
        
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
            
            // Save the profile
            try dataManager.save(profile: profile)
            
            return profile
        } catch {
            generationError = error.localizedDescription
            throw error
        }
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
