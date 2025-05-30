//
//  Cast.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import Foundation
import SwiftData

@Model
class Cast: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var castDescription: String
    var characterIds: [String]
    var createdAt: Date
    var modifiedAt: Date
    
    init(
        id: String = UUID().uuidString,
        name: String,
        castDescription: String = "",
        characterIds: [String] = []
    ) {
        self.id = id
        self.name = name
        self.castDescription = castDescription
        self.characterIds = characterIds
        self.createdAt = .now
        self.modifiedAt = .now
    }
}
