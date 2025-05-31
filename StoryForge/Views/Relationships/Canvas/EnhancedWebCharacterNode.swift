//
//  EnhancedWebCharacterNode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI

// MARK: - Enhanced Character Node for Web View
struct EnhancedWebCharacterNode: View {
    let profile: CharacterProfile
    let position: CGPoint
    let isCenterCharacter: Bool
    let isSelected: Bool
    let isHovered: Bool
    let relationshipCount: Int
    let zoom: CGFloat
    
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    private var nodeColor: Color {
        Color(hex: genre?.color ?? "#808080")
    }
    
    private var nodeSize: CGFloat {
        let baseSize: CGFloat = isCenterCharacter ? 80 : 60
        let scaleFactor = isSelected ? 1.2 : (isHovered ? 1.1 : 1.0)
        return baseSize * scaleFactor / zoom // Adjust for zoom
    }
    
    var body: some View {
        ZStack {
            // Glow effect for center character
            if isCenterCharacter {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                nodeColor.opacity(0.4),
                                nodeColor.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: nodeSize * 0.3,
                            endRadius: nodeSize * 1.5
                        )
                    )
                    .frame(width: nodeSize * 2, height: nodeSize * 2)
                    .blur(radius: 3)
            }
            
            // Selection ring
            if isSelected {
                Circle()
                    .stroke(Color.yellow, lineWidth: 4)
                    .frame(width: nodeSize + 16, height: nodeSize + 16)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isSelected)
            }
            
            // Main node
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            nodeColor,
                            nodeColor.opacity(0.7)
                        ],
                        center: .topLeading,
                        startRadius: nodeSize * 0.1,
                        endRadius: nodeSize * 0.8
                    )
                )
                .frame(width: nodeSize, height: nodeSize)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
            
            // Character initials
            Text(profile.name.prefix(2).uppercased())
                .font(.system(size: nodeSize * 0.35, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2)
            
            // Relationship count badge
            if relationshipCount > 0 && !isCenterCharacter {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    Text("\(relationshipCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: nodeSize * 0.4, y: -nodeSize * 0.4)
            }
            
            // Character name label (shown when hovered or selected)
            if isHovered || isSelected {
                VStack {
                    Spacer()
                    
                    Text(profile.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.7))
                                .overlay(
                                    Capsule()
                                        .stroke(nodeColor, lineWidth: 1)
                                )
                        )
                        .offset(y: nodeSize * 0.7)
                }
                .frame(width: nodeSize, height: nodeSize)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .position(position)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isHovered)
    }
}
