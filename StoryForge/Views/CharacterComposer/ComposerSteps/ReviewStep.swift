//
//  ReviewStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct ReviewStep: View {
    let prompt: String
    let genre: Genre
    let archetype: CharacterArchetype
    let complexity: ComplexityLevel
    let ageRange: String
    let timePeriod: String
    let traits: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Review Your Character")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Everything look good?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Summary Card
                VStack(alignment: .leading, spacing: 16) {
                    // Description
                    ReviewSection(title: "Description", icon: "text.quote") {
                        Text(prompt)
                            .font(.body)
                    }
                    
                    Divider()
                    
                    // Core Details
                    ReviewSection(title: "Core Details", icon: "info.circle") {
                        VStack(alignment: .leading, spacing: 8) {
                            ReviewRow(label: "Genre", value: genre.name, color: Color(hex: genre.color))
                            ReviewRow(label: "Type", value: archetype.name)
                            ReviewRow(label: "Complexity", value: complexity.name)
                        }
                    }
                    
                    if !ageRange.isEmpty || !timePeriod.isEmpty {
                        Divider()
                        
                        // Additional Details
                        ReviewSection(title: "Additional Details", icon: "plus.circle") {
                            VStack(alignment: .leading, spacing: 8) {
                                if !ageRange.isEmpty {
                                    ReviewRow(label: "Age", value: ageRange)
                                }
                                if !timePeriod.isEmpty {
                                    ReviewRow(label: "Period", value: timePeriod)
                                }
                            }
                        }
                    }
                    
                    if !traits.isEmpty {
                        Divider()
                        
                        // Traits
                        ReviewSection(title: "Personality Traits", icon: "sparkles") {
                            FlowLayout(spacing: 6) {
                                ForEach(traits, id: \.self) { trait in
                                    TraitPill(text: trait, color: .blue)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Generation Preview
                GenerationPreviewCard()
                    .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
    }
}
