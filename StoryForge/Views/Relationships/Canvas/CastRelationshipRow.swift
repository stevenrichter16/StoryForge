//
//  CastRelationshipRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CastRelationshipRow: View {
    let relationship: CharacterRelationship
    let fromProfile: CharacterProfile
    let toProfile: CharacterProfile
    let viewingProfile: CharacterProfile?
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 12) {
                // Show both characters if not grouped by character
                if viewingProfile == nil {
                    HStack(spacing: 8) {
                        CharacterBadge(profile: fromProfile)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        CharacterBadge(profile: toProfile)
                    }
                } else {
                    // Show only the other character when grouped
                    let otherProfile = viewingProfile?.id == fromProfile.id ? toProfile : fromProfile
                    CharacterBadge(profile: otherProfile)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(relationship.relationshipType)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(colorForRelationshipType(relationship.relationshipType))
                    
                    if !relationship.characterRelationshipDescription.isEmpty {
                        Text(relationship.characterRelationshipDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            RelationshipDetailView(
                relationship: relationship,
                fromCharacter: fromProfile,
                toCharacter: toProfile
            )
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
