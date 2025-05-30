//
//  GenreCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct GenreCard: View {
    let genre: Genre
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: genre.color).opacity(isSelected ? 0.2 : 0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color(hex: genre.color) : Color.clear, lineWidth: 2)
                        )
                    
                    Text(genre.name)
                        .font(.headline)
                        .foregroundColor(isSelected ? Color(hex: genre.color) : .primary)
                }
                .frame(height: 60)
                
                // World elements preview
                Text(genre.worldElements.prefix(2).joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}
