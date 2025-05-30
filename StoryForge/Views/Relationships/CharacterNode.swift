//
//  CharacterNode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUICore

struct CharacterNode: View {
    let profile: CharacterProfile
    let position: CGPoint
    let size: CGFloat
    let isHighlighted: Bool
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: genre?.color ?? "#808080").opacity(isHighlighted ? 0.3 : 0.2))
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(
                            Color(hex: genre?.color ?? "#808080"),
                            lineWidth: isHighlighted ? 2 : 1
                        )
                )
            
            Text(profile.name.prefix(2).uppercased())
                .font(.system(size: size * 0.3, weight: .semibold))
                .foregroundColor(Color(hex: genre?.color ?? "#808080"))
        }
        .position(position)
        .scaleEffect(isHighlighted ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHighlighted)
    }
}
