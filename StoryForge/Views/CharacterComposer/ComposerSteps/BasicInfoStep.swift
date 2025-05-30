//
//  BasicInfoStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Composer Steps
struct BasicInfoStep: View {
    @Binding var prompt: String
    @Binding var selectedGenre: Genre
    @Binding var selectedArchetype: CharacterArchetype
    @FocusState private var isPromptFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Let's create your character")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Start with a basic description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Character Prompt
                VStack(alignment: .leading, spacing: 8) {
                    Label("Character Description", systemImage: "text.quote")
                        .font(.headline)
                    
                    TextEditor(text: $prompt)
                        .focused($isPromptFocused)
                        .padding(8)
                        .frame(minHeight: 120)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            Group {
                                if prompt.isEmpty {
                                    Text("Describe your character... (e.g., 'A battle-scarred warrior who secretly writes poetry')")
                                        .foregroundColor(.secondary)
                                        .padding(12)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                .padding(.horizontal)
                
                // Genre Selection
                VStack(alignment: .leading, spacing: 12) {
                    Label("Genre", systemImage: "books.vertical")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Genre.all, id: \.id) { genre in
                            GenreCard(
                                genre: genre,
                                isSelected: selectedGenre.id == genre.id,
                                action: { selectedGenre = genre }
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Archetype Selection
                VStack(alignment: .leading, spacing: 12) {
                    Label("Character Type", systemImage: "person.3")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(CharacterArchetype.all, id: \.id) { archetype in
                                ArchetypeCard(
                                    archetype: archetype,
                                    isSelected: selectedArchetype.id == archetype.id,
                                    action: { selectedArchetype = archetype }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
        .onAppear {
            isPromptFocused = true
        }
    }
}
