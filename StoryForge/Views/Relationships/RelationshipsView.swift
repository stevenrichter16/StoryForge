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
    @State private var showingRelationshipList = false
    @State private var viewMode: ViewMode = .cards
    
    enum ViewMode: String, CaseIterable {
        case cards = "Cards"
        case list = "List"
        case web = "Web"
        
        var icon: String {
            switch self {
            case .cards: return "square.grid.2x2"
            case .list: return "list.bullet"
            case .web: return "network"
            }
        }
    }
    
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
                relationshipStats
            }
            
            // View Mode Picker
            if !relationships.isEmpty {
                viewModePicker
                    .padding(.horizontal)
            }
            
            // Content based on view mode
            Group {
                switch viewMode {
                case .cards:
                    cardView
                case .list:
                    listView
                case .web:
                    webPreview
                }
            }
            
            // Add Relationship Button
            addRelationshipButton
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
            EnhancedRelationshipWebView(centerProfile: profile)
        }
        .sheet(isPresented: $showingRelationshipList) {
            RelationshipListView(profile: profile)
        }
    }
    
    // MARK: - View Components
    
    private var relationshipStats: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                RelationshipStat(
                    icon: "person.2.fill",
                    label: "Total",
                    value: "\(relationships.count)"
                )
                
                RelationshipStat(
                    icon: "arrow.left.arrow.right",
                    label: "Mutual",
                    value: "\(twoWayRelationships)"
                )
                
                RelationshipStat(
                    icon: "heart.fill",
                    label: "Close",
                    value: "\(closeRelationships)"
                )
                
                RelationshipStat(
                    icon: "person.2.slash",
                    label: "Rivals",
                    value: "\(rivalRelationships)"
                )
            }
            .padding(.horizontal)
        }
    }
    
    private var viewModePicker: some View {
        Picker("View Mode", selection: $viewMode) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                Label(mode.rawValue, systemImage: mode.icon)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var cardView: some View {
        Group {
            if relationships.isEmpty {
                EmptyRelationshipsView()
            } else {
                // Relationship Web Preview with enhanced interaction
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Relationship Web", systemImage: "network")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Explore") {
                            showingRelationshipWeb = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    
                    // Mini web preview
                    RelationshipWebPreviewCard(
                        profile: profile,
                        relationships: relatedCharacters
                    )
                    .frame(height: 200)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .onTapGesture {
                        showingRelationshipWeb = true
                    }
                }
                .padding(.horizontal)
                
                // Relationship Cards
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
        }
    }
    
    private var listView: some View {
        Group {
            if relationships.isEmpty {
                EmptyRelationshipsView()
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("All Relationships", systemImage: "list.bullet")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Full List") {
                            showingRelationshipList = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(relatedCharacters, id: \.relationship.id) { item in
                                CompactRelationshipRow(
                                    relationship: item.relationship,
                                    otherCharacter: item.character,
                                    currentCharacterId: profile.id,
                                    onTap: { selectedRelationship = item.relationship }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var webPreview: some View {
        Group {
            if relationships.isEmpty {
                EmptyRelationshipsView()
            } else {
                VStack {
                    // Full web embedded
                    RelationshipWebCanvas(centerProfile: profile)
                        .frame(maxHeight: 500)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    
                    Button {
                        showingRelationshipWeb = true
                    } label: {
                        Label("Open Full Screen", systemImage: "arrow.up.left.and.arrow.down.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var addRelationshipButton: some View {
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
    
    // MARK: - Computed Properties
    
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
