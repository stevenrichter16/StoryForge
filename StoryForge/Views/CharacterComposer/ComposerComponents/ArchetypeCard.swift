//
//  ArchetypeCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct ArchetypeCard: View {
    let archetype: CharacterArchetype
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue : Color(.secondarySystemBackground))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: archetype.icon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                
                Text(archetype.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(.primary)
                
                Text(archetype.characterArchetypeDescription)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 100)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
