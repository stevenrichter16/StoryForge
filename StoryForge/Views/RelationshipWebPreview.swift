//
//  RelationshipWebPreview.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct RelationshipWebPreview: View {
    let profile: CharacterProfile
    
    var body: some View {
        ZStack {
            // Placeholder for relationship visualization
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(profile.name.prefix(2))
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .offset(
                        x: cos(CGFloat(index) * 2 * .pi / 3) * 70,
                        y: sin(CGFloat(index) * 2 * .pi / 3) * 70
                    )
            }
        }
    }
}
