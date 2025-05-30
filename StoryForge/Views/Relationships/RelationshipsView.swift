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
    @State private var showingAddRelationship = false
    @State private var selectedRelationship: CharacterRelationship?
    @State private var showingRelationshipWeb = false
    
    private var relationships: [CharacterRelationship] {
        dataManager.relationships(for: profile)
    }
    
    private var relatedCharacters: [(relationship: CharacterRelationship, character: CharacterProfile)] {
        relationships.compactMap { relationship in
            let otherId = relationship.fromCharacterId == profile.id
                ? relationship.toCharacterId
                : relationship.fromCharacterId
            
            if let otherProfile = dataManager.allProfiles.first(where: { $0.id == otherId }) {
                return (relationship, otherProfile)
            }
            return nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Relationship Stats
            if !relationships.isEmpty {
                HStack(spacing: 20) {
                    RelationshipStat(
                        icon: "person.2.fill",
                        label: "Connections",
                        value: "\(relationships.count)"
                    )
                    
                    RelationshipStat(
                        icon: "arrow.left.arrow.right",
                        label: "Two-way",
                        value: "\(twoWayRelationships)"
                    )
                    
                    RelationshipStat(
                        icon: "heart.fill",
                        label: "Close",
                        value: "\(closeRelationships)"
                    )
                }
                .padding(.horizontal)
            }
            
            if relationships.isEmpty {
                EmptyRelationshipsView()
            } else {
                // Relationship Web Preview
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Relationship Web", systemImage: "network")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("View Full") {
                            showingRelationshipWeb = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    
                    RelationshipWebPreview(
                        profile: profile,
                        relationships: relatedCharacters
                    )
                    .frame(height: 200)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Relationship List
                DetailSection(title: "Connections", icon: "person.2") {
                    VStack(spacing: 12) {
                        ForEach(relatedCharacters, id: \.relationship.id) { item in
                            RelationshipCard(
                                relationship: item.relationship,
                                otherCharacter: item.character,
                                currentCharacterId: profile.id,
                                onTap: { selectedRelationship = item.relationship }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Add Relationship Button
            Button {
                showingAddRelationship = true
            } label: {
                Label("Add Relationship", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingAddRelationship) {
            AddRelationshipView(fromProfile: profile)
        }
        .sheet(item: $selectedRelationship) { relationship in
            if let otherChar = relatedCharacters.first(where: { $0.relationship.id == relationship.id })?.character {
                RelationshipDetailView(
                    relationship: relationship,
                    fromCharacter: profile,
                    toCharacter: otherChar
                )
            }
        }
        .sheet(isPresented: $showingRelationshipWeb) {
            FullRelationshipWebView(centerProfile: profile)
        }
    }
    
    private var twoWayRelationships: Int {
        relationships.filter { relationship in
            // Check if there's a reciprocal relationship
            relationships.contains { other in
                other.id != relationship.id &&
                other.fromCharacterId == relationship.toCharacterId &&
                other.toCharacterId == relationship.fromCharacterId
            }
        }.count / 2
    }
    
    private var closeRelationships: Int {
        relationships.filter { relationship in
            let closeTypes = ["Family", "Love Interest", "Best Friend", "Partner"]
            return closeTypes.contains(relationship.relationshipType)
        }.count
    }
}
