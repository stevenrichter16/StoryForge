//
//  TraitPill.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct TraitPill: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}
