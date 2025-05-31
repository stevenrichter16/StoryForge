//
//  CompactRelationshipRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CompactRelationshipRow: View {
    let relationship: CharacterRelationship
    let otherCharacter: CharacterProfile
    let currentCharacterId: String
    let onTap: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    private var relationshipDirection: String {
        relationship.fromCharacterId == currentCharacterId ? "→" : "←"
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Compact avatar
                if let request = dataManager.request(for: otherCharacter) {
                    Circle()
                        .fill(Color(hex: request.genre.color).opacity(0.2))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text(otherCharacter.name.prefix(2).uppercased())
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: request.genre.color))
                        )
                }
                
                // Info
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(otherCharacter.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text(relationshipDirection)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(relationship.relationshipType)
                            .font(.caption)
                            .foregroundColor(colorForRelationshipType(relationship.relationshipType))
                    }
                    
                    if !relationship.characterRelationshipDescription.isEmpty {
                        Text(relationship.characterRelationshipDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    private func colorForRelationshipType(_ type: String) -> Color {
        switch type.lowercased() {
        case "family": return .blue
        case "friend", "best friend": return .green
        case "rival", "enemy": return .red
        case "mentor", "student": return .purple
        case "love interest", "partner": return .pink
        case "colleague": return .orange
        default: return .gray
        }
    }
}
