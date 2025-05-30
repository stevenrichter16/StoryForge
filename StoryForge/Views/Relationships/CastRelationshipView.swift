//
//  CastRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Enhanced Cast Relationship Web View
struct CastRelationshipView: View {
    let cast: Cast
    @EnvironmentObject private var dataManager: DataManager
    @State private var selectedCharacterId: String?
    @State private var hoveredRelationshipId: String?
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var showingLegend = true
    @State private var showingAddRelationship = false
    
    private var castProfiles: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            cast.characterIds.contains(profile.id)
        }
    }
    
    private var allRelationships: [CharacterRelationship] {
        var relationships: [CharacterRelationship] = []
        
        for profile in castProfiles {
            let profileRelationships = dataManager.relationships(for: profile)
                .filter { relationship in
                    // Only include relationships within the cast
                    cast.characterIds.contains(relationship.fromCharacterId) &&
                    cast.characterIds.contains(relationship.toCharacterId)
                }
            relationships.append(contentsOf: profileRelationships)
        }
        
        // Remove duplicates
        return Array(Set(relationships))
    }
    
    private var relationshipTypes: Set<String> {
        Set(allRelationships.map { $0.relationshipType })
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            // Web visualization
            GeometryReader { geometry in
                ZStack {
                    // Relationship connections
                    ForEach(allRelationships) { relationship in
                        RelationshipConnection(
                            relationship: relationship,
                            fromPosition: positionForCharacter(relationship.fromCharacterId, in: geometry.size),
                            toPosition: positionForCharacter(relationship.toCharacterId, in: geometry.size),
                            isHighlighted: hoveredRelationshipId == relationship.id ||
                                         selectedCharacterId == relationship.fromCharacterId ||
                                         selectedCharacterId == relationship.toCharacterId
                        )
                        .onTapGesture {
                            withAnimation {
                                hoveredRelationshipId = relationship.id
                            }
                        }
                    }
                    
                    // Character nodes
                    ForEach(castProfiles) { profile in
                        CastCharacterNode(
                            profile: profile,
                            position: positionForCharacter(profile.id, in: geometry.size),
                            isSelected: selectedCharacterId == profile.id,
                            relationships: relationshipsForCharacter(profile.id)
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedCharacterId = selectedCharacterId == profile.id ? nil : profile.id
                            }
                        }
                    }
                }
                .scaleEffect(zoom)
                .offset(offset)
            }
            
            // Controls overlay
            VStack {
                HStack {
                    // Legend toggle
                    Button {
                        withAnimation {
                            showingLegend.toggle()
                        }
                    } label: {
                        Label(showingLegend ? "Hide Legend" : "Show Legend",
                              systemImage: "list.bullet.rectangle")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Zoom controls
                    HStack(spacing: 12) {
                        Button {
                            withAnimation {
                                zoom = max(0.5, zoom - 0.2)
                            }
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        }
                        
                        Text("\(Int(zoom * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 50)
                        
                        Button {
                            withAnimation {
                                zoom = min(2.0, zoom + 0.2)
                            }
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Legend
                if showingLegend {
                    RelationshipLegend(types: Array(relationshipTypes))
                        .padding()
                }
                
                // Selected character info
                if let selectedId = selectedCharacterId,
                   let selectedProfile = castProfiles.first(where: { $0.id == selectedId }) {
                    SelectedCharacterInfo(
                        profile: selectedProfile,
                        relationships: relationshipsForCharacter(selectedId),
                        onClose: { selectedCharacterId = nil }
                    )
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(cast.name) Relationships")
                    .font(.headline)
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
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    zoom = value
                }
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation
                }
        )
    }
    
    private func positionForCharacter(_ characterId: String, in size: CGSize) -> CGPoint {
        guard let index = cast.characterIds.firstIndex(of: characterId) else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        
        let count = cast.characterIds.count
        let angle = (CGFloat(index) / CGFloat(count)) * 2 * .pi - .pi / 2
        let radius = min(size.width, size.height) * 0.35
        
        return CGPoint(
            x: size.width / 2 + cos(angle) * radius,
            y: size.height / 2 + sin(angle) * radius
        )
    }
    
    private func relationshipsForCharacter(_ characterId: String) -> [CharacterRelationship] {
        allRelationships.filter { relationship in
            relationship.fromCharacterId == characterId ||
            relationship.toCharacterId == characterId
        }
    }
}
