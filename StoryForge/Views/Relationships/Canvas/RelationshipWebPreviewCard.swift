//
//  RelationshipWebPreviewCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct RelationshipWebPreviewCard: View {
    let profile: CharacterProfile
    let relationships: [(relationship: CharacterRelationship, character: CharacterProfile)]
    @EnvironmentObject private var dataManager: DataManager
    @State private var hoveredCharacterId: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Simplified web visualization
                ForEach(Array(relationships.enumerated()), id: \.element.relationship.id) { index, item in
                    let angle = (CGFloat(index) / CGFloat(relationships.count)) * 2 * .pi
                    let radius = min(geometry.size.width, geometry.size.height) * 0.35
                    let endPoint = CGPoint(
                        x: geometry.size.width / 2 + cos(angle) * radius,
                        y: geometry.size.height / 2 + sin(angle) * radius
                    )
                    
                    // Connection line
                    Path { path in
                        path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                        path.addLine(to: endPoint)
                    }
                    .stroke(
                        colorForRelationshipType(item.relationship.relationshipType).opacity(0.3),
                        lineWidth: 1
                    )
                    
                    // Character node
                    MiniCharacterNode(
                        profile: item.character,
                        position: endPoint,
                        isHovered: hoveredCharacterId == item.character.id
                    )
                    .onHover { isHovered in
                        hoveredCharacterId = isHovered ? item.character.id : nil
                    }
                }
                
                // Center character
                MiniCharacterNode(
                    profile: profile,
                    position: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                    isCenter: true,
                    isHovered: false
                )
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
        case "colleague": return .orange
        default: return .gray
        }
    }
}
