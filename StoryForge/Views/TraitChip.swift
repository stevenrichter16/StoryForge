//
//  TraitChip.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct TraitChip: View {
    let trait: String
    let color: Color
    
    var body: some View {
        Text(trait)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(20)
    }
}
