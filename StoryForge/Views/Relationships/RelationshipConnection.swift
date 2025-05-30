//
//  RelationshipConnection.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Supporting Components
struct RelationshipConnection: View {
    let relationship: CharacterRelationship
    let fromPosition: CGPoint
    let toPosition: CGPoint
    let isHighlighted: Bool
    
    @State private var animationPhase: CGFloat = 0
    
    private var connectionColor: Color {
        colorForRelationshipType(relationship.relationshipType)
    }
    
    var body: some View {
        ZStack {
            // Connection line
            Path { path in
                path.move(to: fromPosition)
                
                // Create a curved path
                let midX = (fromPosition.x + toPosition.x) / 2
                let midY = (fromPosition.y + toPosition.y) / 2
                let offsetX = (toPosition.y - fromPosition.y) * 0.2
                let offsetY = (fromPosition.x - toPosition.x) * 0.2
                
                path.addQuadCurve(
                    to: toPosition,
                    control: CGPoint(x: midX + offsetX, y: midY + offsetY)
                )
            }
            .stroke(
                connectionColor.opacity(isHighlighted ? 0.8 : 0.4),
                style: StrokeStyle(
                    lineWidth: isHighlighted ? 3 : 2,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: relationship.characterRelationshipDescription.isEmpty ? [] : [5, 5]
                )
            )
            
            // Animated particles for highlighted connections
            if isHighlighted {
                Path { path in
                    path.move(to: fromPosition)
                    let midX = (fromPosition.x + toPosition.x) / 2
                    let midY = (fromPosition.y + toPosition.y) / 2
                    let offsetX = (toPosition.y - fromPosition.y) * 0.2
                    let offsetY = (fromPosition.x - toPosition.x) * 0.2
                    
                    path.addQuadCurve(
                        to: toPosition,
                        control: CGPoint(x: midX + offsetX, y: midY + offsetY)
                    )
                }
                .trim(from: animationPhase - 0.1, to: animationPhase)
                .stroke(
                    connectionColor,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        animationPhase = 1.1
                    }
                }
            }
            
            // Relationship type indicator at midpoint
            if isHighlighted && !relationship.characterRelationshipDescription.isEmpty {
                Text(relationship.relationshipType)
                    .font(.caption)
                    .padding(4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(4)
                    .position(
                        x: (fromPosition.x + toPosition.x) / 2,
                        y: (fromPosition.y + toPosition.y) / 2
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
