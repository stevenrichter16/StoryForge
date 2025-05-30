//
//  ReviewRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUICore

struct ReviewRow: View {
    let label: String
    let value: String
    var color: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}
