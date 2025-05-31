//
//  RelationshipRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Relationship Row

struct RelationshipRow: View {
    let relationship: CharacterRelationship
    let otherCharacter: CharacterProfile
    let currentCharacterId: String
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingDetail = false
    @State private var showingCharacterDetail = false
    
    private var relationshipDirection: String {
        relationship.fromCharacterId == currentCharacterId ? "→" : "←"
    }
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 16) {
                // Character Avatar
                if let request = dataManager.request(for: otherCharacter) {
                    Circle()
                        .fill(Color(hex: request.genre.color).opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(otherCharacter.name.prefix(2).uppercased())
                                .font(.headline)
                                .foregroundColor(Color(hex: request.genre.color))
                        )
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(otherCharacter.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(relationshipDirection)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
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
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                // Delete relationship
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                showingCharacterDetail = true
            } label: {
                Label("View", systemImage: "person.text.rectangle")
            }
            .tint(.blue)
        }
        .sheet(isPresented: $showingDetail) {
            if let fromProfile = dataManager.allProfiles.first(where: { $0.id == currentCharacterId }) {
                RelationshipDetailView(
                    relationship: relationship,
                    fromCharacter: fromProfile,
                    toCharacter: otherCharacter
                )
            }
        }
        .sheet(isPresented: $showingCharacterDetail) {
            if let request = dataManager.request(for: otherCharacter) {
                CharacterDetailView(profile: otherCharacter, request: request)
            }
        }
    }
}
