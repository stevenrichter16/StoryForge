//
//  SelectedCharacterInfo.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct SelectedCharacterInfo: View {
    let profile: CharacterProfile
    let relationships: [CharacterRelationship]
    let onClose: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(profile.name)
                    .font(.headline)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            Text("\(relationships.count) relationships in this cast")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Relationship breakdown
            HStack(spacing: 16) {
                ForEach(groupedRelationshipTypes, id: \.type) { group in
                    VStack(spacing: 2) {
                        Text("\(group.count)")
                            .font(.headline)
                            .foregroundColor(colorForRelationshipType(group.type))
                        
                        Text(group.type)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
    
    private var groupedRelationshipTypes: [(type: String, count: Int)] {
        let groups = Dictionary(grouping: relationships) { $0.relationshipType }
        return groups.map { (type: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
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
