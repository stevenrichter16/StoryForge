//
//  RelationshipWebPreview.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Enhanced Relationship Web Preview
struct RelationshipWebPreview: View {
    let profile: CharacterProfile
    let relationships: [(relationship: CharacterRelationship, character: CharacterProfile)]
    @EnvironmentObject private var dataManager: DataManager
    @State private var hoveredCharacterId: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemBackground))
                
                // Connections
                ForEach(Array(relationships.enumerated()), id: \.element.relationship.id) { index, item in
                    Path { path in
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        let angle = (CGFloat(index) / CGFloat(relationships.count)) * 2 * .pi
                        let radius = min(geometry.size.width, geometry.size.height) * 0.35
                        let endPoint = CGPoint(
                            x: center.x + cos(angle) * radius,
                            y: center.y + sin(angle) * radius
                        )
                        
                        path.move(to: center)
                        path.addLine(to: endPoint)
                    }
                    .stroke(
                        colorForRelationshipType(item.relationship.relationshipType).opacity(0.5),
                        lineWidth: hoveredCharacterId == item.character.id ? 3 : 1
                    )
                }
                
                // Center character
                CharacterNode(
                    profile: profile,
                    position: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                    size: 60,
                    isHighlighted: true
                )
                
                // Related characters
                ForEach(Array(relationships.enumerated()), id: \.element.character.id) { index, item in
                    let angle = (CGFloat(index) / CGFloat(relationships.count)) * 2 * .pi
                    let radius = min(geometry.size.width, geometry.size.height) * 0.35
                    let position = CGPoint(
                        x: geometry.size.width / 2 + cos(angle) * radius,
                        y: geometry.size.height / 2 + sin(angle) * radius
                    )
                    
                    CharacterNode(
                        profile: item.character,
                        position: position,
                        size: 40,
                        isHighlighted: hoveredCharacterId == item.character.id
                    )
                    .onHover { isHovered in
                        hoveredCharacterId = isHovered ? item.character.id : nil
                    }
                }
            }
        }
    }
    
    private func colorForRelationshipType(_ type: String) -> Color {
        switch type.lowercased() {
        case "family": return .blue
        case "friend", "best friend": return .green
        case "rival", "enemy": return .red
        case "mentor", "student": return .purple
        case "love interest", "partner": return .pink
        default: return .gray
        }
    }
}
