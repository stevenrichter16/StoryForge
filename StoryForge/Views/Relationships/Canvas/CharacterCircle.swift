//
//  CharacterCircle.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Character Circle Component

struct CharacterCircle: View {
    let profile: CharacterProfile
    let size: CGFloat
    @EnvironmentObject private var dataManager: DataManager
    
    private var genreColor: Color {
        if let request = dataManager.request(for: profile) {
            return Color(hex: request.genre.color)
        }
        return .gray
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(genreColor.opacity(0.2))
                    .frame(width: size, height: size)
                
                Circle()
                    .stroke(genreColor, lineWidth: 2)
                    .frame(width: size, height: size)
                
                Text(profile.name.prefix(2).uppercased())
                    .font(.system(size: size * 0.35, weight: .bold))
                    .foregroundColor(genreColor)
            }
            
            Text(profile.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}
