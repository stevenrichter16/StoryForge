//
//  MiniCharacterNode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct MiniCharacterNode: View {
    let profile: CharacterProfile
    let position: CGPoint
    var isCenter: Bool = false
    let isHovered: Bool
    @EnvironmentObject private var dataManager: DataManager
    
    private var nodeSize: CGFloat {
        isCenter ? 50 : 40
    }
    
    var body: some View {
        ZStack {
            if let request = dataManager.request(for: profile) {
                Circle()
                    .fill(Color(hex: request.genre.color).opacity(isCenter ? 0.3 : 0.2))
                    .frame(width: nodeSize, height: nodeSize)
                    .overlay(
                        Circle()
                            .stroke(
                                Color(hex: request.genre.color),
                                lineWidth: isCenter ? 2.5 : 2
                            )
                    )
                
                Text(profile.name.prefix(2).uppercased())
                    .font(.system(size: nodeSize * 0.35, weight: .semibold))
                    .foregroundColor(Color(hex: request.genre.color))
            }
        }
        .position(position)
        .scaleEffect(isHovered ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovered)
    }
}
