//
//  BasicCharacterInfoStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Basic Character Info Step
struct BasicCharacterInfoStep: View {
    @Binding var selectedGenre: Genre
    @Binding var selectedArchetype: CharacterArchetype
    @Binding var selectedComplexity: ComplexityLevel
    @Binding var characterName: String
    @Binding var characterAge: String
    @Binding var characterOccupation: String
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, age, occupation
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Basic Information")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Start with the essentials")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Character Name
                VStack(alignment: .leading, spacing: 8) {
                    Label("Character Name", systemImage: "person.fill")
                        .font(.headline)
                    
                    TextField("Enter character name", text: $characterName)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .name)
                }
                .padding(.horizontal)
                
                // Age & Occupation
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Age", systemImage: "calendar")
                            .font(.headline)
                        
                        TextField("Age", text: $characterAge)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .age)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Occupation", systemImage: "briefcase")
                            .font(.headline)
                        
                        TextField("Occupation", text: $characterOccupation)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .occupation)
                    }
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
                
                // Complexity Level
                VStack(alignment: .leading, spacing: 12) {
                    Label("Complexity", systemImage: "slider.horizontal.3")
                        .font(.headline)
                    
                    ForEach(ComplexityLevel.all, id: \.id) { level in
                        ComplexityCard(
                            level: level,
                            isSelected: selectedComplexity.id == level.id,
                            action: { selectedComplexity = level }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
        .onAppear {
            focusedField = .name
        }
    }
}
