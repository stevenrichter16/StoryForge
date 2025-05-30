//
//  TraitSelectionStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Trait Selection Step
struct TraitSelectionStep: View {
    @Binding var selectedTraits: [String: Set<CharacterTrait>]
    @State private var expandedCategories: Set<String> = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Character Traits")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Select traits that define your character")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Trait Categories
                ForEach(CharacterTraitDatabase.categories) { category in
                    TraitCategoryView(
                        category: category,
                        selectedTraits: bindingForCategory(category.name),
                        isExpanded: expandedCategories.contains(category.name),
                        onToggleExpand: {
                            withAnimation {
                                if expandedCategories.contains(category.name) {
                                    expandedCategories.remove(category.name)
                                } else {
                                    expandedCategories.insert(category.name)
                                }
                            }
                        }
                    )
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private func bindingForCategory(_ categoryName: String) -> Binding<Set<CharacterTrait>> {
        Binding(
            get: { selectedTraits[categoryName] ?? [] },
            set: { selectedTraits[categoryName] = $0 }
        )
    }
}
