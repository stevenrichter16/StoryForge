//
//  CustomTraitChip.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CustomTraitChip: View {
    let trait: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(trait)
                .font(.caption)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.purple.opacity(0.2))
        .foregroundColor(.purple)
        .cornerRadius(16)
    }
}
