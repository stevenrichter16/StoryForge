//
//  QuickStartCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct QuickStartCard: View {
    let template: CharacterTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: template.icon)
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: template.genre.color),
                                Color(hex: template.genre.color).opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color(hex: template.genre.color).opacity(0.2))
                    )
                
                Text(template.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100, height: 120)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: template.genre.color).opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
