//
//  AllTraitsView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct AllTraitsView: View {
    let profile: CharacterProfile
    @State private var expandedCategories: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if profile.allSelectedTraits.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "sparkles.slash")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("No Traits Selected")
                        .font(.headline)
                    
                    Text("This character was created without trait selection")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Trait Summary
                        TraitSummaryHeader(profile: profile)
                            .padding(.horizontal)
                        
                        // Categories
                        ForEach(profile.traitsByCategory, id: \.category) { item in
                            TraitCategorySection(
                                category: item.category,
                                traits: item.traits,
                                isExpanded: expandedCategories.contains(item.category),
                                onToggle: {
                                    withAnimation {
                                        if expandedCategories.contains(item.category) {
                                            expandedCategories.remove(item.category)
                                        } else {
                                            expandedCategories.insert(item.category)
                                        }
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear {
            // Expand categories with traits by default
            expandedCategories = Set(profile.allSelectedTraits.keys)
            
            // Debug logging
            print("=== AllTraitsView Debug ===")
            print("Profile: \(profile.name)")
            print("All Selected Traits: \(profile.allSelectedTraits)")
            print("Categories: \(profile.allSelectedTraits.keys)")
            for (category, traits) in profile.allSelectedTraits {
                print("  \(category): \(traits.count) traits - \(traits)")
            }
            print("========================")
        }
    }
}


