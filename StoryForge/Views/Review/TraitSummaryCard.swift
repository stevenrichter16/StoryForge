//
//  TraitSummaryCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Trait Summary Card
struct TraitSummaryCard: View {
    let selectedTraits: [String: Set<CharacterTrait>]
    
    private var totalTraitCount: Int {
        selectedTraits.values.reduce(0) { $0 + $1.count }
    }
    
    private var categoryCount: Int {
        selectedTraits.values.filter { !$0.isEmpty }.count
    }
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("\(totalTraitCount)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Total Traits")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
                .frame(height: 40)
            
            VStack {
                Text("\(categoryCount)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text("Categories")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
}
