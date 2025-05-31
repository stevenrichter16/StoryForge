//
//  LoadingView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI


// MARK: - Loading View
struct LoadingView: View {
    @State private var animationProgress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated loader
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: animationProgress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                // Center icon
                Image(systemName: "network")
                    .font(.title)
                    .foregroundColor(.white)
                    .scaleEffect(pulseScale)
            }
            
            Text("Building Relationship Web")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Analyzing connections...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .onAppear {
            // Circular progress animation
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animationProgress = 1.0
            }
            
            // Pulse animation
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulseScale = 1.15
            }
        }
    }
}
