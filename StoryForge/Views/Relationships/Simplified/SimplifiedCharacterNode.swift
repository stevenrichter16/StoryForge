//
//  SimplifiedCharacterNode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI


// MARK: - Simplified Character Node
struct SimplifiedCharacterNode: View {
    let profile: CharacterProfile
    let position: CGPoint
    let isCenterCharacter: Bool
    let isSelected: Bool
    let relationshipCount: Int
    let onTap: () -> Void
    
    @EnvironmentObject private var dataManager: DataManager
    
    private var nodeColor: Color {
        if let request = dataManager.request(for: profile) {
            return Color(hex: request.genre.color)
        }
        return .gray
    }
    
    private var nodeSize: CGFloat {
        isCenterCharacter ? 70 : 50
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Main circle
                Circle()
                    .fill(nodeColor.opacity(isCenterCharacter ? 0.4 : 0.3))
                    .frame(width: nodeSize, height: nodeSize)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.yellow : nodeColor, lineWidth: isSelected ? 3 : 2)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Initials
                Text(profile.name.prefix(2).uppercased())
                    .font(.system(size: nodeSize * 0.35, weight: .bold))
                    .foregroundColor(.white)
                
                // Badge
                if relationshipCount > 0 && !isCenterCharacter {
                    Text("\(relationshipCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Circle().fill(Color.blue))
                        .offset(x: nodeSize * 0.35, y: -nodeSize * 0.35)
                }
                
                // Name label for center character
                if isCenterCharacter {
                    Text(profile.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 2)
                        )
                        .offset(y: nodeSize * 0.8)
                }
            }
        }
        .position(position)
        .buttonStyle(.plain)
        .onAppear {
            if isCenterCharacter {
                print("🎯 Center node appeared at position: \(position)")
            }
        }
    }
}
