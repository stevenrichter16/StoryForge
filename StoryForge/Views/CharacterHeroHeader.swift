//
//  CharacterHeroHeader.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Hero Header
struct CharacterHeroHeader: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    
    var body: some View {
        VStack(spacing: 16) {
            // Character Avatar Placeholder
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: request.genre.color),
                                Color(hex: request.genre.color).opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Text(profile.name.prefix(2).uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .shadow(color: Color(hex: request.genre.color).opacity(0.3), radius: 10, y: 5)
            
            // Name and Title
            VStack(spacing: 8) {
                Text(profile.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(profile.occupation)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if let age = profile.age {
                    Text("Age \(age)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Tagline
            Text(profile.tagline)
                .font(.body)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            // Quick Stats
            HStack(spacing: 20) {
                StatBadge(
                    icon: "brain",
                    label: "Traits",
                    value: "\(profile.personalityTraits.count)"
                )
                
                StatBadge(
                    icon: "book.closed",
                    label: "Events",
                    value: "\(profile.keyLifeEvents.count)"
                )
                
                StatBadge(
                    icon: "person.2",
                    label: "Relations",
                    value: "\(profile.relationshipIds.count)"
                )
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.secondarySystemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
