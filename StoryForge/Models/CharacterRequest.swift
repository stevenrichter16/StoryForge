import Foundation
import SwiftData

@Model
class CharacterRequest: Identifiable {
    @Attribute(.unique) var id: String
    var userPrompt: String
    var genre: Genre
    var archetype: CharacterArchetype
    var complexityLevel: ComplexityLevel
    var ageRange: String?
    var timePeriod: String?
    var additionalTraits: [String]
    var createdAt: Date
    
    // ID references
    var profileId: String?
    var castId: String?
    
    init(
        id: String = UUID().uuidString,
        userPrompt: String,
        genre: Genre,
        archetype: CharacterArchetype,
        complexityLevel: ComplexityLevel,
        ageRange: String? = nil,
        timePeriod: String? = nil,
        additionalTraits: [String] = [],
        createdAt: Date = .now
    ) {
        self.id = id
        self.userPrompt = userPrompt
        self.genre = genre
        self.archetype = archetype
        self.complexityLevel = complexityLevel
        self.ageRange = ageRange
        self.timePeriod = timePeriod
        self.additionalTraits = additionalTraits
        self.createdAt = createdAt
    }
}
