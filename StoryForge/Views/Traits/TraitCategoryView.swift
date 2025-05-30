//
//  TraitCategoryView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Trait Category View
struct TraitCategoryView: View {
    let category: CharacterTraitCategory
    @Binding var selectedTraits: Set<CharacterTrait>
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Category Header
            Button(action: onToggleExpand) {
                HStack {
                    Label(category.name, systemImage: category.icon)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if category.isRequired {
                        Text("Required")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if !selectedTraits.isEmpty {
                            Text("\(selectedTraits.count)")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    // Category Description
                    Text(category.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Selection Info
                    if !category.allowsMultiple {
                        Text("Select one")
                            .font(.caption2)
                            .foregroundColor(.orange)
                            .padding(.horizontal)
                    }
                    
                    // Trait Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(category.traits) { trait in
                            TraitSelectionCard(
                                trait: trait,
                                isSelected: selectedTraits.contains(trait),
                                action: {
                                    if category.allowsMultiple {
                                        if selectedTraits.contains(trait) {
                                            selectedTraits.remove(trait)
                                        } else {
                                            selectedTraits.insert(trait)
                                        }
                                    } else {
                                        // Single selection - clear others
                                        selectedTraits.removeAll()
                                        selectedTraits.insert(trait)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
