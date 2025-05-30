//
//  CharacterRelationship.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import Foundation
import SwiftData

@Model
class CharacterRelationship: Identifiable {
    @Attribute(.unique) var id: String
    var fromCharacterId: String
    var toCharacterId: String
    var relationshipType: String
    var characterRelationshipDescription: String
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        fromCharacterId: String,
        toCharacterId: String,
        relationshipType: String,
        characterRelationshipDescription: String = ""
    ) {
        self.id = id
        self.fromCharacterId = fromCharacterId
        self.toCharacterId = toCharacterId
        self.relationshipType = relationshipType
        self.characterRelationshipDescription = characterRelationshipDescription
        self.createdAt = .now
    }
}
