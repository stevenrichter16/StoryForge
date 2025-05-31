//
//  CastRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Enhanced Cast Relationship Web View
// MARK: - Enhanced Cast Relationship Web View
struct CastRelationshipView: View {
    let cast: Cast
    @EnvironmentObject private var dataManager: DataManager
    @State private var selectedCharacterId: String?
    @State private var hoveredRelationshipId: String?
    @State private var showingLegend = true
    @State private var showingAddRelationship = false
    @State private var showingCharacterDetail = false
    @State private var detailProfile: CharacterProfile?
    @State private var viewMode: ViewMode = .web
    @State private var filterRelationshipType: String? = nil
    
    enum ViewMode: String, CaseIterable {
        case web = "Web"
        case matrix = "Matrix"
        case list = "List"
        
        var icon: String {
            switch self {
            case .web: return "network"
            case .matrix: return "square.grid.3x3"
            case .list: return "list.bullet"
            }
        }
    }
    
    private var castProfiles: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            cast.characterIds.contains(profile.id)
        }
    }
    
    private var allRelationships: [CharacterRelationship] {
        var relationships: [CharacterRelationship] = []
        var seenPairs = Set<String>()
        
        for profile in castProfiles {
            let profileRelationships = dataManager.relationships(for: profile)
                .filter { relationship in
                    // Only include relationships within the cast
                    cast.characterIds.contains(relationship.fromCharacterId) &&
                    cast.characterIds.contains(relationship.toCharacterId)
                }
            
            for relationship in profileRelationships {
                // Create a unique key for the relationship pair
                let key = [relationship.fromCharacterId, relationship.toCharacterId].sorted().joined(separator: "-")
                if !seenPairs.contains(key) {
                    seenPairs.insert(key)
                    relationships.append(relationship)
                }
            }
        }
        
        // Apply filter if set
        if let filterType = filterRelationshipType {
            return relationships.filter { $0.relationshipType == filterType }
        }
        
        return relationships
    }
    
    private var relationshipTypes: [String] {
        Array(Set(allRelationships.map { $0.relationshipType })).sorted()
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            // Content based on view mode
            Group {
                switch viewMode {
                case .web:
                    if let centerProfile = getCenterProfile() {
                        RelationshipWebCanvas(centerProfile: centerProfile)
                            .environment(\.castContext, CastContext(cast: cast, filteredRelationships: allRelationships))
                    } else {
                        emptyCastView
                    }
                    
                case .matrix:
                    RelationshipMatrixView(
                        cast: cast,
                        profiles: castProfiles,
                        relationships: allRelationships
                    )
                    
                case .list:
                    CastRelationshipListView(
                        cast: cast,
                        profiles: castProfiles,
                        relationships: allRelationships
                    )
                }
            }
            
            // Overlay controls
            VStack {
                // Top controls
                HStack {
                    // View mode picker
                    Menu {
                        ForEach(ViewMode.allCases, id: \.self) { mode in
                            Button {
                                withAnimation {
                                    viewMode = mode
                                }
                            } label: {
                                Label(mode.rawValue, systemImage: mode.icon)
                            }
                        }
                    } label: {
                        Label(viewMode.rawValue, systemImage: viewMode.icon)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Filter menu
                    if !relationshipTypes.isEmpty {
                        Menu {
                            Button {
                                filterRelationshipType = nil
                            } label: {
                                Label("All Types", systemImage: filterRelationshipType == nil ? "checkmark" : "")
                            }
                            
                            Divider()
                            
                            ForEach(relationshipTypes, id: \.self) { type in
                                Button {
                                    filterRelationshipType = type
                                } label: {
                                    Label(
                                        type,
                                        systemImage: filterRelationshipType == type ? "checkmark" : ""
                                    )
                                }
                            }
                        } label: {
                            Label(
                                filterRelationshipType ?? "All Types",
                                systemImage: "line.3.horizontal.decrease.circle"
                            )
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        }
                    }
                    
                    // Legend toggle (for web view)
                    if viewMode == .web {
                        Button {
                            withAnimation {
                                showingLegend.toggle()
                            }
                        } label: {
                            Label(
                                showingLegend ? "Hide Legend" : "Show Legend",
                                systemImage: "list.bullet.rectangle"
                            )
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Bottom overlays
                VStack(spacing: 16) {
                    // Legend (for web view)
                    if viewMode == .web && showingLegend && !relationshipTypes.isEmpty {
                        RelationshipLegend(types: relationshipTypes)
                            .padding(.horizontal)
                    }
                    
                    // Cast info card
                    CastInfoCard(
                        cast: cast,
                        characterCount: castProfiles.count,
                        relationshipCount: allRelationships.count
                    )
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(cast.name)
                        .font(.headline)
                    Text("\(castProfiles.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddRelationship = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddRelationship) {
            AddCastRelationshipView(cast: cast)
        }
        .sheet(isPresented: $showingCharacterDetail) {
            if let profile = detailProfile,
               let request = dataManager.request(for: profile) {
                CharacterDetailView(profile: profile, request: request)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getCenterProfile() -> CharacterProfile? {
        // Try to get the selected character first
        if let selectedId = selectedCharacterId,
           let profile = castProfiles.first(where: { $0.id == selectedId }) {
            return profile
        }
        
        // Otherwise, find the character with the most relationships
        let characterRelationshipCounts = castProfiles.map { profile in
            let count = allRelationships.filter { relationship in
                relationship.fromCharacterId == profile.id ||
                relationship.toCharacterId == profile.id
            }.count
            return (profile: profile, count: count)
        }
        
        return characterRelationshipCounts.max(by: { $0.count < $1.count })?.profile ?? castProfiles.first
    }
    
    private var emptyCastView: some View {
        ContentUnavailableView(
            "No Characters",
            systemImage: "person.3.slash",
            description: Text("Add characters to this cast to see their relationships")
        )
    }
}
