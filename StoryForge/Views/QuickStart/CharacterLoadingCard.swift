//
//  CharacterLoadingCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CharacterLoadingCard: View {
    let request: CharacterRequest
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Loading avatar
            Circle()
                .fill(Color(hex: request.genre.color).opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    ProgressView()
                        .scaleEffect(0.6)
                )
            
            // Info
            VStack(alignment: .leading, spacing: 2) {
                Text("Generating...")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("\(request.genre.name) • \(request.archetype.name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Animation dots
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color(hex: request.genre.color))
                        .frame(width: 4, height: 4)
                        .opacity(isAnimating ? 0.3 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .onAppear {
            isAnimating = true
        }
    }
}
