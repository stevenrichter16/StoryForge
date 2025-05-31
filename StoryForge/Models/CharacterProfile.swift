import Foundation
import SwiftData

@Model
class CharacterProfile: Identifiable {
    @Attribute(.unique) var id: String
    var requestId: String
    
    // Basic Info
    var name: String
    var age: Int?
    var occupation: String
    var tagline: String
    
    // Appearance
    var physicalDescription: String
    var distinguishingFeatures: [String]
    
    // Personality
    var personalityTraits: [String]
    var coreBelief: String
    var fears: [String]
    var desires: [String]
    
    // Background
    var backstory: String
    var keyLifeEvents: [String]
    var secrets: [String]
    
    // Story Elements
    var motivations: [String]
    var internalConflict: String
    var externalConflict: String
    var characterArc: String
    
    // Relationships
    var relationshipIds: [String] = []
    
    // ALL TRAITS STORAGE - NEW
    var allSelectedTraits: [String: [String]] = [:]
    
    // Metadata
    var isFavorite: Bool
    var hasAnimated: Bool
    var dateCreated: Date
    var lastModified: Date
    
    // Computed properties for traits
    var traitsByCategory: [(category: String, traits: [String])] {
        allSelectedTraits
            .sorted { $0.key < $1.key }
            .map { (category: $0.key, traits: $0.value) }
    }
    
    var allTraitNames: [String] {
        allSelectedTraits.values.flatMap { $0 }
    }
    
    func hasTraits(in category: String) -> Bool {
        guard let traits = allSelectedTraits[category] else { return false }
        return !traits.isEmpty
    }
    
    init(
        id: String = UUID().uuidString,
        requestId: String,
        name: String,
        age: Int? = nil,
        occupation: String,
        tagline: String,
        physicalDescription: String = "",
        personalityTraits: [String] = [],
        backstory: String = "",
        isFavorite: Bool = false,
        hasAnimated: Bool = false
    ) {
        self.id = id
        self.requestId = requestId
        self.name = name
        self.age = age
        self.occupation = occupation
        self.tagline = tagline
        self.physicalDescription = physicalDescription
        self.distinguishingFeatures = []
        self.personalityTraits = personalityTraits
        self.coreBelief = ""
        self.fears = []
        self.desires = []
        self.backstory = backstory
        self.keyLifeEvents = []
        self.secrets = []
        self.motivations = []
        self.internalConflict = ""
        self.externalConflict = ""
        self.characterArc = ""
        self.isFavorite = isFavorite
        self.hasAnimated = hasAnimated
        self.dateCreated = .now
        self.lastModified = .now
        self.allSelectedTraits = [:]
    }
}
