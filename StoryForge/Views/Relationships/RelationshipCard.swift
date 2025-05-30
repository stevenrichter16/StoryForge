//
//  RelationshipCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct RelationshipCard: View {
    let relationship: CharacterRelationship
    let otherCharacter: CharacterProfile
    let currentCharacterId: String
    let onTap: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    private var relationshipDirection: String {
        if relationship.fromCharacterId == currentCharacterId {
            return "→"
        } else {
            return "←"
        }
    }
    
    private var otherCharacterGenre: Genre? {
        guard let request = dataManager.request(for: otherCharacter) else { return nil }
        return request.genre
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Character Avatar
                ZStack {
                    Circle()
                        .fill(Color(hex: otherCharacterGenre?.color ?? "#808080").opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(otherCharacter.name.prefix(2).uppercased())
                        .font(.headline)
                        .foregroundColor(Color(hex: otherCharacterGenre?.color ?? "#808080"))
                }
                
                // Relationship Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(otherCharacter.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(relationshipDirection)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label(relationship.relationshipType, systemImage: iconForRelationshipType(relationship.relationshipType))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if !relationship.characterRelationshipDescription.isEmpty {
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text(relationship.characterRelationshipDescription)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    private func iconForRelationshipType(_ type: String) -> String {
        switch type.lowercased() {
        case "family": return "person.2.fill"
        case "friend", "best friend": return "person.2"
        case "rival", "enemy": return "person.2.slash"
        case "mentor": return "person.fill.questionmark"
        case "student": return "studentdesk"
        case "love interest", "partner": return "heart.fill"
        case "colleague": return "briefcase"
        default: return "person.2"
        }
    }
}
