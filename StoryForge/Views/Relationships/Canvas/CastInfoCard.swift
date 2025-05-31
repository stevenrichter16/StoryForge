//
//  CastInfoCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CastInfoCard: View {
    let cast: Cast
    let characterCount: Int
    let relationshipCount: Int
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(characterCount)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Characters")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
                .frame(height: 40)
            
            VStack(spacing: 4) {
                Text("\(relationshipCount)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text("Relationships")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !cast.castDescription.isEmpty {
                Divider()
                    .frame(height: 40)
                
                Text(cast.castDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

