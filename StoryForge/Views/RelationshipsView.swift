//
//  RelationshipsView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Relationships View
struct RelationshipsView: View {
    let profile: CharacterProfile
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if profile.relationshipIds.isEmpty {
                EmptyRelationshipsView()
            } else {
                // Relationship Web Preview
                RelationshipWebPreview(profile: profile)
                    .frame(height: 200)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                // Relationship List
                DetailSection(title: "Connections", icon: "person.2") {
                    VStack(spacing: 12) {
                        // Placeholder for actual relationships
                        ForEach(0..<3, id: \.self) { _ in
                            RelationshipCard()
                        }
                    }
                }
            }
            
            // Add Relationship Button
            Button {
                // Add relationship action
            } label: {
                Label("Add Relationship", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }
}
