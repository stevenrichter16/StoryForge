//
//  MatrixCell.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct MatrixCell: View {
    let fromProfile: CharacterProfile
    let toProfile: CharacterProfile
    let relationship: CharacterRelationship?
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Rectangle()
                    .fill(cellColor)
                    .border(
                        isSelected ? Color.blue : Color(.separator),
                        width: isSelected ? 2 : 0.5
                    )
                
                if let relationship = relationship {
                    VStack(spacing: 2) {
                        Image(systemName: iconForRelationshipType(relationship.relationshipType))
                            .font(.caption)
                            .foregroundColor(colorForRelationshipType(relationship.relationshipType))
                        
                        if relationship.fromCharacterId == fromProfile.id {
                            Image(systemName: "arrow.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        } else {
                            Image(systemName: "arrow.left")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                } else if fromProfile.id == toProfile.id {
                    // Diagonal cell
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 60, height: 60)
        }
        .buttonStyle(.plain)
    }
    
    private var cellColor: Color {
        if fromProfile.id == toProfile.id {
            return Color(.tertiarySystemBackground)
        } else if relationship != nil {
            return colorForRelationshipType(relationship!.relationshipType).opacity(0.1)
        } else {
            return Color(.systemBackground)
        }
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
