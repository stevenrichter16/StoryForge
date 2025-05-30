//
//  StoryNotesView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Story Notes View
struct StoryNotesView: View {
    let profile: CharacterProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Motivations
            if !profile.motivations.isEmpty {
                DetailSection(title: "Motivations", icon: "flag.fill") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(profile.motivations, id: \.self) { motivation in
                            MotivationCard(motivation: motivation)
                        }
                    }
                }
            }
            
            // Character Arc
            DetailSection(title: "Character Arc", icon: "arrow.triangle.turn.up.right.circle") {
                Text(profile.characterArc)
                    .font(.body)
                    .lineSpacing(4)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
            }
            
            // Story Integration Ideas
            DetailSection(title: "Story Ideas", icon: "lightbulb") {
                VStack(alignment: .leading, spacing: 12) {
                    StoryIdeaCard(
                        title: "Opening Scene",
                        idea: "Introduce through their daily routine, showing personality"
                    )
                    StoryIdeaCard(
                        title: "Conflict Introduction",
                        idea: "First encounter with main antagonist at a public event"
                    )
                    StoryIdeaCard(
                        title: "Character Growth",
                        idea: "Forced to confront their biggest fear to save someone"
                    )
                }
            }
        }
    }
}
