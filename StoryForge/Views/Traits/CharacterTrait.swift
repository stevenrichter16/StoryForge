//
//  CharacterTrait.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import Foundation

struct CharacterTrait: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let category: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CharacterTrait, rhs: CharacterTrait) -> Bool {
        lhs.id == rhs.id
    }
}
