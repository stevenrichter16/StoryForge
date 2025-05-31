//
//  TraitSummaryHeader.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct TraitSummaryHeader: View {
    let profile: CharacterProfile
    
    private var totalTraitCount: Int {
        profile.allTraitNames.count
    }
    
    private var categoryCount: Int {
        profile.allSelectedTraits.filter { !$0.value.isEmpty }.count
    }
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("\(totalTraitCount)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Total Traits")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
                .frame(height: 40)
            
            VStack(alignment: .leading) {
                Text("\(categoryCount)")
                    .font(.title)
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
