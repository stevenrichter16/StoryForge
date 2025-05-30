//
//  CharacterReviewStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Character Review Step
struct CharacterReviewStep: View {
    let characterData: CharacterCreationData
    let selectedTraits: [String: Set<CharacterTrait>]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Review Your Character")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Ready to bring them to life?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Character Summary Card
                VStack(alignment: .leading, spacing: 20) {
                    // Basic Info
                    ReviewSection(title: "Basic Information", icon: "person.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            ReviewRow(label: "Name", value: characterData.name)
                            if !characterData.age.isEmpty {
                                ReviewRow(label: "Age", value: characterData.age)
                            }
                            if !characterData.occupation.isEmpty {
                                ReviewRow(label: "Occupation", value: characterData.occupation)
                            }
                            ReviewRow(label: "Genre", value: characterData.genre.name, color: Color(hex: characterData.genre.color))
                            ReviewRow(label: "Type", value: characterData.archetype.name)
                            ReviewRow(label: "Complexity", value: characterData.complexity.name)
                        }
                    }
                    
                    // Check if there are any selected traits
                    if selectedTraits.values.contains(where: { !$0.isEmpty }) {
                        Divider()
                        
                        // Selected Traits
                        ReviewSection(title: "Character Traits", icon: "sparkles") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(CharacterTraitDatabase.categories) { category in
                                    if let traits = selectedTraits[category.name], !traits.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Image(systemName: category.icon)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(category.name)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            FlowLayout(spacing: 6) {
                                                ForEach(Array(traits)) { trait in
                                                    TraitPill(text: trait.name)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if !characterData.additionalNotes.isEmpty {
                        Divider()
                        
                        // Additional Notes
                        ReviewSection(title: "Additional Notes", icon: "note.text") {
                            Text(characterData.additionalNotes)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // AI Generation Preview
                AIGenerationPreview()
                    .padding(.horizontal)
                
                // Trait Summary Stats
                if selectedTraits.values.contains(where: { !$0.isEmpty }) {
                    TraitSummaryCard(selectedTraits: selectedTraits)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 100)
        }
    }
}
