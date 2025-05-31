//
//  TraitCategorySection.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct TraitCategorySection: View {
    let category: String
    let traits: [String]
    let isExpanded: Bool
    let onToggle: () -> Void
    
    private var categoryInfo: (icon: String, color: Color) {
        // Match with CharacterTraitDatabase categories
        switch category {
        case "Physical Build": return ("figure.stand", .orange)
        case "Core Personality": return ("brain", .blue)
        case "Social Style": return ("person.3", .green)
        case "Moral Alignment": return ("scale.3d", .purple)
        case "Notable Skills": return ("star.circle", .yellow)
        case "Background": return ("clock.arrow.circlepath", .brown)
        case "Quirks & Flaws": return ("sparkles", .pink)
        case "Core Motivation": return ("flag.fill", .red)
        default: return ("questionmark.circle", .gray)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack {
                    Label(category, systemImage: categoryInfo.icon)
                        .font(.headline)
                        .foregroundColor(categoryInfo.color)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("\(traits.count)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(categoryInfo.color.opacity(0.2))
                            .foregroundColor(categoryInfo.color)
                            .cornerRadius(4)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    FlowLayout(spacing: 8) {
                        ForEach(traits, id: \.self) { trait in
                            TraitPill(
                                text: trait,
                                color: categoryInfo.color
                            )
                            Text(trait.description)
                        }
                        
                    }
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
    }
}
