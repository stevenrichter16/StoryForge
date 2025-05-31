//
//  WebVisualizationContent.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI


// MARK: - Web Visualization Content
struct WebVisualizationContent: View {
    let centerProfile: CharacterProfile
    let nodePositions: [String: CGPoint]
    let relationships: [CharacterRelationship]
    let profiles: [CharacterProfile]
    @Binding var selectedCharacterId: String?
    @Binding var hoveredCharacterId: String?
    @Binding var zoom: CGFloat
    @Binding var offset: CGSize
    @Binding var gestureOffset: CGSize
    let onNodeTap: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Debug background
                Color.gray.opacity(0.1)
                    .onAppear {
                        print("🖼️ Web visualization geometry: \(geometry.size)")
                        print("📊 Rendering \(relationships.count) relationships")
                        print("👥 Rendering \(profiles.count) profiles")
                    }
                
                // Static relationship lines (no animation for performance)
                ForEach(relationships, id: \.id) { relationship in
                    if let fromPos = nodePositions[relationship.fromCharacterId],
                       let toPos = nodePositions[relationship.toCharacterId] {
                        SimplifiedConnectionLine(
                            relationship: relationship,
                            from: transformPoint(fromPos),
                            to: transformPoint(toPos),
                            isHighlighted: isRelationshipHighlighted(relationship)
                        )
                    }
                }
                
                // Character nodes
                ForEach(profiles, id: \.id) { profile in
                    if let position = nodePositions[profile.id] {
                        SimplifiedCharacterNode(
                            profile: profile,
                            position: transformPoint(position),
                            isCenterCharacter: profile.id == centerProfile.id,
                            isSelected: selectedCharacterId == profile.id,
                            relationshipCount: relationshipCount(for: profile),
                            onTap: { onNodeTap(profile.id) }
                        )
                    } else {
                        let _ = print("⚠️ No position for profile: \(profile.name)")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            zoom = max(0.5, min(3.0, value))
                        },
                    DragGesture()
                        .onChanged { value in
                            gestureOffset = value.translation
                        }
                        .onEnded { value in
                            offset.width += value.translation.width
                            offset.height += value.translation.height
                            gestureOffset = .zero
                        }
                )
            )
        }
    }
    
    private func transformPoint(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x * zoom + offset.width + gestureOffset.width,
            y: point.y * zoom + offset.height + gestureOffset.height
        )
    }
    
    private func relationshipCount(for profile: CharacterProfile) -> Int {
        relationships.filter { relationship in
            relationship.fromCharacterId == profile.id ||
            relationship.toCharacterId == profile.id
        }.count
    }
    
    private func isRelationshipHighlighted(_ relationship: CharacterRelationship) -> Bool {
        guard let selectedId = selectedCharacterId else { return false }
        return relationship.fromCharacterId == selectedId ||
               relationship.toCharacterId == selectedId
    }
}
