//
//  SimplifiedConnectionLine.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI


// MARK: - Simplified Connection Line (No animation for performance)
struct SimplifiedConnectionLine: View {
    let relationship: CharacterRelationship
    let from: CGPoint
    let to: CGPoint
    let isHighlighted: Bool
    
    private var connectionColor: Color {
        switch relationship.relationshipType.lowercased() {
        case "family": return .blue
        case "friend", "best friend": return .green
        case "rival", "enemy": return .red
        case "mentor", "student": return .purple
        case "love interest", "partner": return .pink
        case "colleague": return .orange
        default: return .gray
        }
    }
    
    var body: some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(
            connectionColor.opacity(isHighlighted ? 0.8 : 0.4),
            lineWidth: isHighlighted ? 3 : 1.5
        )
    }
}
