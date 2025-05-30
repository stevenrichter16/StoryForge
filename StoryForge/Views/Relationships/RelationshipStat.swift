//
//  RelationshipStat.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Supporting Components
struct RelationshipStat: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
