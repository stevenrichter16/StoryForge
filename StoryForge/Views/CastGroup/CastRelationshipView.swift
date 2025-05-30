//
//  CastRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CastRelationshipView: View {
    let cast: Cast
    
    var body: some View {
        VStack {
            Text("Character Relationships")
                .font(.headline)
                .padding()
            
            // Placeholder for relationship visualization
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                
                Text("Relationship web visualization")
                    .foregroundColor(.secondary)
            }
        }
    }
}
