//
//  PreGeneratedCharacterCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI

// MARK: - Character Card for Carousel
// MARK: - Optimized Character Card
struct PreGeneratedCharacterCard: View {
    let request: CharacterRequest
    let profile: CharacterProfile
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Genre & Archetype header
            HStack {
                Label(request.genre.name, systemImage: "sparkle")
                    .font(.caption)
                    .foregroundColor(Color(hex: request.genre.color))
                
                Spacer()
                
                Text(request.archetype.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Character info
            VStack(alignment: .leading, spacing: 8) {
                Text(profile.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(profile.occupation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(profile.tagline)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .italic()
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Traits preview - simplified
            if !profile.personalityTraits.isEmpty {
                HStack(spacing: 4) {
                    ForEach(profile.personalityTraits.prefix(3), id: \.self) { trait in
                        Text(trait)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: request.genre.color).opacity(0.2))
                            .foregroundColor(Color(hex: request.genre.color))
                            .cornerRadius(12)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color(hex: request.genre.color).opacity(isPressed ? 0.6 : 0.3),
                    lineWidth: isPressed ? 2 : 1
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
            isPressed = pressing
        }) {
            onLongPress()
            HapticFeedback.success()
        }
    }
}
