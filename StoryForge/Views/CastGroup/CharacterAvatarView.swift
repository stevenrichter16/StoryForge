//
//  CharacterAvatarView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CharacterAvatarView: View {
    let profile: CharacterProfile
    let genre: Genre
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: genre.color).opacity(0.3))
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Text(profile.name.prefix(2).uppercased())
                .font(.system(size: size * 0.35, weight: .semibold))
                .foregroundColor(Color(hex: genre.color))
        }
    }
}
