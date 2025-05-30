//
//  AIGenerationPreview.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct AIGenerationPreview: View {
    @State private var animationPhase = 0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "wand.and.stars")
                    .font(.title2)
                    .foregroundColor(.purple)
                    .rotationEffect(.degrees(animationPhase == 1 ? 360 : 0))
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: animationPhase)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI-Powered Generation")
                        .font(.headline)
                    
                    Text("Your character will be enriched with detailed personality, backstory, and unique characteristics")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .onAppear {
            animationPhase = 1
        }
    }
}
