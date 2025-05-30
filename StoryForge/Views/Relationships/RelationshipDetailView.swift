//
//  RelationshipDetailVeiw.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Relationship Detail View
struct RelationshipDetailView: View {
    let relationship: CharacterRelationship
    let fromCharacter: CharacterProfile
    let toCharacter: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Character visualization
                HStack(spacing: 40) {
                    CharacterNode(profile: fromCharacter, position: .zero, size: 80, isHighlighted: true)
                    
                    VStack {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundColor(.secondary)
                        
                        Text(relationship.relationshipType)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    CharacterNode(profile: toCharacter, position: .zero, size: 80, isHighlighted: true)
                }
                .padding()
                
                // Relationship details
                if !relationship.characterRelationshipDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Description", systemImage: "text.quote")
                            .font(.headline)
                        
                        Text(relationship.characterRelationshipDescription)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Metadata
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Created", systemImage: "calendar")
                            .font(.caption)
                        
                        Spacer()
                        
                        Text(relationship.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Relationship Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
