//
//  EnhancedRelationshipWebPreview.swift
//  StoryForge
//
//  Updated to use fixed components
//

import SwiftUI

// MARK: - Enhanced Relationship Web Preview
struct EnhancedRelationshipWebPreview: View {
    let profile: CharacterProfile
    let relationships: [(relationship: CharacterRelationship, character: CharacterProfile)]
    let onExplore: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    @State private var hoveredCharacterId: String?
    @State private var selectedCharacterId: String?
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Label("Relationship Web", systemImage: "network")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Explore", action: onExplore)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            // Enhanced web visualization
            GeometryReader { geometry in
                ZStack {
                    // Background with subtle grid
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(.tertiarySystemBackground),
                                    Color(.quaternarySystemFill)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            GridPattern()
                                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                        )
                    
                    // Relationship connections
                    ForEach(Array(relationships.enumerated()), id: \.element.relationship.id) { index, item in
                        EnhancedConnectionLine(
                            relationship: item.relationship,
                            from: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                            to: positionForRelationship(index, in: geometry.size),
                            isHighlighted: hoveredCharacterId == item.character.id ||
                                         selectedCharacterId == item.character.id,
                            zoom: 1.0
                        )
                    }
                    
                    // Center character
                    UnifiedCharacterNode(
                        profile: profile,
                        position: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                        context: .preview(isCenterCharacter: true),
                        isSelected: selectedCharacterId == profile.id,
                        isHovered: false,
                        relationshipCount: relationships.count,
                        zoom: 1.0,
                        onTap: {
                            withAnimation {
                                if selectedCharacterId == profile.id {
                                    selectedCharacterId = nil
                                } else {
                                    selectedCharacterId = profile.id
                                }
                            }
                        }
                    )
                    
                    // Related characters
                    ForEach(Array(relationships.enumerated()), id: \.element.character.id) { index, item in
                        UnifiedCharacterNode(
                            profile: item.character,
                            position: positionForRelationship(index, in: geometry.size),
                            context: .preview(isCenterCharacter: false),
                            isSelected: selectedCharacterId == item.character.id,
                            isHovered: hoveredCharacterId == item.character.id,
                            relationshipCount: 1,
                            zoom: 1.0,
                            onTap: {
                                withAnimation {
                                    if selectedCharacterId == item.character.id {
                                        selectedCharacterId = nil
                                    } else {
                                        selectedCharacterId = item.character.id
                                    }
                                }
                            }
                        )
                        .onHover { isHovered in
                            hoveredCharacterId = isHovered ? item.character.id : nil
                        }
                    }
                }
            }
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
        )
        .padding(.horizontal)
    }
    
    private func positionForRelationship(_ index: Int, in size: CGSize) -> CGPoint {
        let angle = (CGFloat(index) / CGFloat(relationships.count)) * 2 * .pi - .pi / 2
        let radius = min(size.width, size.height) * 0.32
        
        return CGPoint(
            x: size.width / 2 + cos(angle) * radius,
            y: size.height / 2 + sin(angle) * radius
        )
    }
}

// MARK: - Grid Pattern
struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let gridSize: CGFloat = 20
        
        // Vertical lines
        for x in stride(from: 0, to: rect.width, by: gridSize) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        // Horizontal lines
        for y in stride(from: 0, to: rect.height, by: gridSize) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}
