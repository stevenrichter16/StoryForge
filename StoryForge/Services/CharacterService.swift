import Foundation
import SwiftData

@MainActor
final class CharacterService: ObservableObject {
    private let dataManager: DataManager
    @Published var isGenerating: Bool = false
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func generateCharacter(request: CharacterRequest) async throws -> CharacterProfile {
        isGenerating = true
        defer { isGenerating = false }
        
        // Build the prompt
        let systemPrompt = """
        You are a master storyteller and character creator. Create rich, complex characters with depth and nuance.
        Provide detailed information including:
        - Name and basic demographics
        - Physical appearance and distinguishing features
        - Personality traits and core beliefs
        - Backstory and key life events
        - Motivations, fears, and desires
        - Internal and external conflicts
        - Potential character arc
        
        Format the response as a structured character profile.
        """
        
        let userPrompt = buildPrompt(from: request)
        
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
    }
    
    private func buildPrompt(from request: CharacterRequest) -> String {
        var prompt = "\(request.archetype.prompt)\(request.userPrompt)"
        prompt += "\n\nGenre: \(request.genre.name)"
        
        if let ageRange = request.ageRange {
            prompt += "\nAge Range: \(ageRange)"
        }
        
        if let timePeriod = request.timePeriod {
            prompt += "\nTime Period: \(timePeriod)"
        }
        
        if !request.additionalTraits.isEmpty {
            prompt += "\nAdditional Traits: \(request.additionalTraits.joined(separator: ", "))"
        }
        
        return prompt
    }
    
    private func parseCharacterProfile(from content: String, requestId: String) throws -> CharacterProfile {
        // This is a simplified parser - in production, you'd want more robust parsing
        // possibly using structured output from OpenAI or JSON mode
        
        let profile = CharacterProfile(
            requestId: requestId,
            name: extractSection(from: content, section: "Name") ?? "Unknown Character",
            occupation: extractSection(from: content, section: "Occupation") ?? "Unknown",
            tagline: extractSection(from: content, section: "Tagline") ?? content.prefix(100).trimmingCharacters(in: .whitespacesAndNewlines),
            physicalDescription: extractSection(from: content, section: "Appearance") ?? "",
            backstory: extractSection(from: content, section: "Backstory") ?? content
        )
        
        // Parse other sections...
        profile.personalityTraits = extractList(from: content, section: "Personality Traits")
        profile.fears = extractList(from: content, section: "Fears")
        profile.desires = extractList(from: content, section: "Desires")
        profile.motivations = extractList(from: content, section: "Motivations")
        
        return profile
    }
    
    private func extractSection(from content: String, section: String) -> String? {
        // Implementation to extract specific sections from the generated content
        // This is a placeholder - implement based on your response format
        return nil
    }
    
    private func extractList(from content: String, section: String) -> [String] {
        // Implementation to extract lists from the generated content
        return []
    }
}
