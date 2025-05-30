//
//  QuickStartSection.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Quick Start Templates
struct QuickStartSection: View {
    let onQuickCreate: (CharacterTemplate) -> Void
    
    let templates = [
        CharacterTemplate(
            name: "Fantasy Hero",
            icon: "sparkles",
            genre: Genre.all[0], // Fantasy
            archetype: CharacterArchetype.all[0], // Hero
            complexity: ComplexityLevel.all[1] // Detailed
        ),
        CharacterTemplate(
            name: "Sci-Fi Villain",
            icon: "bolt.fill",
            genre: Genre.all[1], // Sci-Fi
            archetype: CharacterArchetype.all[2], // Villain
            complexity: ComplexityLevel.all[2] // Complex
        ),
        CharacterTemplate(
            name: "Mystery Sidekick",
            icon: "magnifyingglass",
            genre: Genre.all[4], // Mystery
            archetype: CharacterArchetype.all[3], // Sidekick
            complexity: ComplexityLevel.all[0] // Simple
        ),
        CharacterTemplate(
            name: "Historical Mentor",
            icon: "clock.fill",
            genre: Genre.all[2], // Historical
            archetype: CharacterArchetype.all[1], // Mentor
            complexity: ComplexityLevel.all[1] // Detailed
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Quick Start", systemImage: "bolt.fill")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(templates) { template in
                        QuickStartCard(
                            template: template,
                            action: { onQuickCreate(template) }
                        )
                    }
                }
            }
        }
    }
}
