//
//  RelationshipsView.swift
//  StoryForge
//
//  Enhanced with better visual hierarchy and design
//

import SwiftUI

// MARK: - Enhanced Relationships View
struct RelationshipsView: View {
    let profile: CharacterProfile
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingAddRelationship = false
    @State private var selectedRelationship: CharacterRelationship?
    @State private var showingRelationshipWeb = false
    @State private var selectedViewMode: RelationshipViewMode = .cards
    
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
        VStack(spacing: 0) {
            // Enhanced header with stats and view mode selector
            VStack(spacing: 16) {
                // Stats overview
                if !relationships.isEmpty {
                    RelationshipStatsCard(
                        totalConnections: relationships.count,
                        twoWayConnections: twoWayRelationships,
                        closeConnections: closeRelationships,
                        rivalConnections: rivalRelationships
                    )
                }
                
                // View mode picker
                ViewModePicker(selectedMode: $selectedViewMode)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            
            // Content based on selected view mode
            ScrollView {
                LazyVStack(spacing: 16) {
                    if relationships.isEmpty {
                        EmptyRelationshipsCard()
                            .padding()
                    } else {
                        switch selectedViewMode {
                        case .cards:
                            RelationshipCardsView(
                                profile: profile,
                                relatedCharacters: relatedCharacters,
                                onRelationshipTap: { selectedRelationship = $0 }
                            )
                        case .list:
                            RelationshipListContentView(
                                profile: profile,
                                relatedCharacters: relatedCharacters,
                                onRelationshipTap: { selectedRelationship = $0 }
                            )
                        case .web:
                            EnhancedRelationshipWebPreview(
                                profile: profile,
                                relationships: relatedCharacters,
                                onExplore: { showingRelationshipWeb = true }
                            )
                        }
                    }
                    
                    // Add relationship button
                    AddRelationshipCard(action: { showingAddRelationship = true })
                        .padding(.horizontal)
                }
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemGroupedBackground))
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
        // Use the optimized web view instead
        .sheet(isPresented: $showingRelationshipWeb) {
            OptimizedFullRelationshipWebView(centerProfile: profile)
        }
    }
    
    
    private var twoWayRelationships: Int {
        relationships.filter { relationship in
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
    
    private var rivalRelationships: Int {
        relationships.filter { relationship in
            let rivalTypes = ["Rival", "Enemy"]
            return rivalTypes.contains(relationship.relationshipType)
        }.count
    }
}

// MARK: - Empty Relationships Card
struct EmptyRelationshipsCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Relationships Yet")
                    .font(.headline)
                
                Text("Connect your character to others to build their world")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.tertiarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                )
        )
    }
}

// MARK: - Add Relationship Card
struct AddRelationshipCard: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Add New Relationship")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Relationship Cards View
struct RelationshipCardsView: View {
    let profile: CharacterProfile
    let relatedCharacters: [(relationship: CharacterRelationship, character: CharacterProfile)]
    let onRelationshipTap: (CharacterRelationship) -> Void
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(relatedCharacters, id: \.relationship.id) { item in
                RelationshipCardView(
                    relationship: item.relationship,
                    character: item.character,
                    onTap: { onRelationshipTap(item.relationship) }
                )
            }
        }
        .padding(.horizontal)
    }
}

struct RelationshipCardView: View {
    let relationship: CharacterRelationship
    let character: CharacterProfile
    let onTap: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: character) else { return nil }
        return request.genre
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Character avatar
                ZStack {
                    Circle()
                        .fill(Color(hex: genre?.color ?? "#808080").opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(character.name.prefix(2).uppercased())
                        .font(.headline)
                        .foregroundColor(Color(hex: genre?.color ?? "#808080"))
                }
                
                // Character info
                VStack(spacing: 4) {
                    Text(character.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Label(relationship.relationshipType, systemImage: iconForRelationType(relationship.relationshipType))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func iconForRelationType(_ type: String) -> String {
        switch type.lowercased() {
        case "family": return "person.2.fill"
        case "friend": return "person.2"
        case "rival": return "person.2.slash"
        case "mentor": return "person.fill.questionmark"
        default: return "person.2"
        }
    }
}

// MARK: - Relationship List Content View
struct RelationshipListContentView: View {
    let profile: CharacterProfile
    let relatedCharacters: [(relationship: CharacterRelationship, character: CharacterProfile)]
    let onRelationshipTap: (CharacterRelationship) -> Void
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(relatedCharacters, id: \.relationship.id) { item in
                RelationshipCard(
                    relationship: item.relationship,
                    otherCharacter: item.character,
                    currentCharacterId: profile.id,
                    onTap: { onRelationshipTap(item.relationship) }
                )
            }
        }
        .padding(.horizontal)
    }
}
