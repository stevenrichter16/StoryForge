//
//  CastCharacterNode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CastCharacterNode: View {
    let profile: CharacterProfile
    let position: CGPoint
    let isSelected: Bool
    let relationships: [CharacterRelationship]
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    private var nodeSize: CGFloat {
        isSelected ? 80 : 60
    }
    
    var body: some View {
        ZStack {
            // Relationship count indicator
            if !relationships.isEmpty {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(
                        width: nodeSize + CGFloat(relationships.count) * 10,
                        height: nodeSize + CGFloat(relationships.count) * 10
                    )
            }
            
            // Main node
            Circle()
                .fill(Color(hex: genre?.color ?? "#808080").opacity(0.3))
                .frame(width: nodeSize, height: nodeSize)
                .overlay(
                    Circle()
                        .stroke(
                            isSelected ? Color.yellow : Color(hex: genre?.color ?? "#808080"),
                            lineWidth: isSelected ? 3 : 2
                        )
                )
            
            // Character info
            VStack(spacing: 4) {
                Text(profile.name.prefix(2).uppercased())
                    .font(.system(size: nodeSize * 0.3, weight: .bold))
                    .foregroundColor(Color(hex: genre?.color ?? "#808080"))
                
                if isSelected {
                    Text(profile.name)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
            }
            
            // Relationship count badge
            if !relationships.isEmpty {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                    
                    Text("\(relationships.count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .offset(x: nodeSize * 0.35, y: -nodeSize * 0.35)
            }
        }
        .position(position)
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
