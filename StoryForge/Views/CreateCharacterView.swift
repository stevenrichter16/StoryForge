//
//  CreateCardView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Views/Create/CreateCharacterView.swift
import SwiftUI

struct CreateCharacterView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var characterService: CharacterService
    @State private var showingComposer = false
    @State private var selectedGenre: Genre = Genre.all[0]
    @State private var selectedArchetype: CharacterArchetype = CharacterArchetype.all[0]
    @State private var selectedComplexity: ComplexityLevel = ComplexityLevel.all[1]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Header Section
                        VStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .symbolRenderingMode(.hierarchical)
                            
                            Text("Create Your Character")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Build rich, detailed characters with AI assistance")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                        // Quick Start Section
                        QuickStartSection(
                            onQuickCreate: { template in
                                // Pre-fill the composer with template data
                                applyTemplate(template)
                                showingComposer = true
                            }
                        )
                        .padding(.horizontal)
                        
                        // Recent creations
                        if !dataManager.allRequests.isEmpty {
                            RecentCreationsSection()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Floating action button
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: { showingComposer = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                Text("New Character")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .blue.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Create")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingComposer) {
                CharacterComposerView(
                    selectedGenre: $selectedGenre,
                    selectedArchetype: $selectedArchetype,
                    selectedComplexity: $selectedComplexity,
                    onSubmit: { characterData in
                        createCharacterWithEnhancedData(characterData)
                        showingComposer = false
                    }
                )
            }
        }
    }
    
    // MARK: - Helper Methods
    // Also add this helper method if it's missing:
    private func extractTraitNames(from traitDict: [String: Set<CharacterTrait>]) -> [String] {
        var allTraits: [String] = []
        
        for (categoryName, traits) in traitDict {
            let traitNames = traits.map { $0.name }
            allTraits.append(contentsOf: traitNames)
            
            // Debug logging
            if !traitNames.isEmpty {
                print("  Extracting from \(categoryName): \(traitNames.joined(separator: ", "))")
            }
        }
        
        return allTraits
    }
    
    private func applyTemplate(_ template: CharacterTemplate) {
        selectedGenre = template.genre
        selectedArchetype = template.archetype
        selectedComplexity = template.complexity
    }
    

    private func createCharacterWithEnhancedData(_ characterData: CharacterCreationData) {
        // Debug logging at the start
        print("=== createCharacterWithEnhancedData START ===")
        print("Character Name: \(characterData.name)")
        print("Selected Traits from characterData:")
        for (category, traits) in characterData.traits {
            if !traits.isEmpty {
                print("  \(category): \(traits.map { $0.name }.joined(separator: ", "))")
            }
        }
        
        // Build a more detailed prompt that includes trait information
        var fullPrompt = characterData.buildPrompt()
        print("\nBase Prompt Generated:")
        print(fullPrompt)
        
        // Extract personality traits specifically for the AI
        let personalityTraits = characterData.traits["Core Personality"]?.map { $0.name } ?? []
        if !personalityTraits.isEmpty {
            fullPrompt += "\n\nCore personality traits: \(personalityTraits.joined(separator: ", "))"
            print("\nPersonality traits added to prompt: \(personalityTraits)")
        } else {
            print("\n⚠️ No Core Personality traits found!")
        }
        
        // Extract all trait names
        let allTraitNames = extractTraitNames(from: characterData.traits)
        print("\nAll extracted trait names: \(allTraitNames)")
        
        // Create the character request with all the data
        let request = CharacterRequest(
            userPrompt: fullPrompt,
            genre: characterData.genre,
            archetype: characterData.archetype,
            complexityLevel: characterData.complexity,
            ageRange: characterData.age.isEmpty ? nil : characterData.age,
            timePeriod: nil,
            additionalTraits: allTraitNames
        )
        
        print("\nCharacterRequest created:")
        print("  - Genre: \(request.genre.name)")
        print("  - Archetype: \(request.archetype.name)")
        print("  - Additional Traits: \(request.additionalTraits)")
        
        do {
            try dataManager.save(request: request)
            print("✅ Request saved to dataManager")
            
            Task {
                do {
                    print("\n🔄 Starting character generation...")
                    let profile = try await characterService.generateCharacter(request: request)
                    
                    print("\n📝 Profile generated:")
                    print("  - Name: \(profile.name)")
                    print("  - Personality Traits from AI: \(profile.personalityTraits)")
                    
                    // Update the profile with the selected personality traits
                    if let personalityTraits = characterData.traits["Core Personality"], !personalityTraits.isEmpty {
                        let originalTraits = profile.personalityTraits
                        profile.personalityTraits = Array(personalityTraits.map { $0.name })
                        
                        print("\n🔄 Updating personality traits:")
                        print("  - Original from AI: \(originalTraits)")
                        print("  - Replaced with user selection: \(profile.personalityTraits)")
                        
                        // BUG FIX: You need to save the profile, not the request again
                        try dataManager.save(profile: profile)
                        print("✅ Profile updated and saved")
                    } else {
                        print("\n⚠️ No Core Personality traits to update")
                    }
                    
                    print("\n✅ Character created successfully with traits: \(profile.personalityTraits)")
                    print("=== createCharacterWithEnhancedData END ===\n")
                    
                } catch {
                    print("\n❌ Failed to generate character: \(error)")
                    print("Error details: \(error.localizedDescription)")
                    print("=== createCharacterWithEnhancedData END (with error) ===\n")
                }
            }
        } catch {
            print("\n❌ Failed to save request: \(error)")
            print("Error details: \(error.localizedDescription)")
            print("=== createCharacterWithEnhancedData END (with error) ===\n")
        }
    }
    
    // Original simple creation method (if still needed for backward compatibility)
    private func createCharacter(prompt: String, traits: [String]) {
        let request = CharacterRequest(
            userPrompt: prompt,
            genre: selectedGenre,
            archetype: selectedArchetype,
            complexityLevel: selectedComplexity,
            additionalTraits: traits
        )
        
        do {
            try dataManager.save(request: request)
            
            Task {
                do {
                    let _ = try await characterService.generateCharacter(request: request)
                } catch {
                    print("Failed to generate character: \(error)")
                }
            }
        } catch {
            print("Failed to save request: \(error)")
        }
    }
}

