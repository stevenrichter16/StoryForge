//
//  RelationshipLegend.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Enhanced Relationship Legend
struct EnhancedRelationshipLegend: View {
    let types: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Relationship Types")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(types.sorted(), id: \.self) { type in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(colorForRelationshipType(type))
                            .frame(width: 12, height: 12)
                        
                        Text(type)
                            .font(.caption2)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
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
