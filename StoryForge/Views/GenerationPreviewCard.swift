//
//  GenerationPreviewCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct GenerationPreviewCard: View {
    @State private var animationPhase = 0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(animationPhase == 1 ? 360 : 0))
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: animationPhase)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ready to Create")
                        .font(.headline)
                    
                    Text("Your character will be generated with rich details and personality")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
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
