//
//  CreateCharacterView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct CreateCharacterView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var characterService: CharacterService
    @State private var showingComposer = false
    @State private var selectedGenre: Genre = Genre.all[0]
    @State private var selectedArchetype: CharacterArchetype = CharacterArchetype.all[0]
    @State private var selectedComplexity: ComplexityLevel = ComplexityLevel.all[1]
    @State private var isGeneratingCharacter = false
    @State private var generationError: String?
    @State private var showingError = false
    
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
                        
                        // Generation status
                        if isGeneratingCharacter {
                            GenerationStatusCard()
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
                        .disabled(isGeneratingCharacter)
                        .opacity(isGeneratingCharacter ? 0.6 : 1.0)
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
            .alert("Error Creating Character", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(generationError ?? "An unknown error occurred")
            }
        }
        .onReceive(characterService.$isGenerating) { isGenerating in
            isGeneratingCharacter = isGenerating
        }
        .onReceive(characterService.$generationError) { error in
            if let error = error {
                generationError = error
                showingError = true
            }
        }
    }
    
    // MARK: - Helper Methods
    private func applyTemplate(_ template: CharacterTemplate) {
        selectedGenre = template.genre
        selectedArchetype = template.archetype
        selectedComplexity = template.complexity
    }
    
    private func createCharacterWithEnhancedData(_ characterData: CharacterCreationData) {
        // Debug logging
        print("\n=== createCharacterWithEnhancedData START ===")
        characterData.debugPrintTraits()
        
        // Validate input
        guard !characterData.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            generationError = "Character name cannot be empty"
            showingError = true
            return
        }
        
        // Create the character request
        let request = CharacterRequest(
            userPrompt: characterData.buildPrompt(),
            genre: characterData.genre,
            archetype: characterData.archetype,
            complexityLevel: characterData.complexity,
            ageRange: characterData.age.isEmpty ? nil : characterData.age,
            timePeriod: nil,
            additionalTraits: characterData.getAllTraitNames()
        )
        
        print("\nCharacterRequest created:")
        print("  - Genre: \(request.genre.name)")
        print("  - Archetype: \(request.archetype.name)")
        print("  - Additional Traits: \(request.additionalTraits.count) traits")
        
        // Set generating state
        isGeneratingCharacter = true
        
        do {
            try dataManager.save(request: request)
            print("✅ Request saved to dataManager")
            
            Task {
                do {
                    print("\n🔄 Starting character generation...")
                    
                    // Use the new method that preserves user data
                    let profile = try await characterService.generateCharacterWithUserData(
                        request: request,
                        characterData: characterData
                    )
                    
                    print("\n✅ Character created successfully:")
                    print("  - Name: \(profile.name)")
                    print("  - Age: \(profile.age ?? 0)")
                    print("  - Occupation: \(profile.occupation)")
                    print("  - Personality Traits: \(profile.personalityTraits)")
                    print("  - All Traits: \(profile.allTraitNames.count) traits in \(profile.allSelectedTraits.count) categories")
                    
                    // Update UI on main thread
                    await MainActor.run {
                        isGeneratingCharacter = false
                        
                        // Refresh data to show new character
                        dataManager.loadData()
                        
                        // Optional: Show success feedback
                        HapticFeedback.success()
                    }
                    
                    print("=== createCharacterWithEnhancedData END ===\n")
                    
                } catch {
                    print("\n❌ Failed to generate character: \(error)")
                    print("Error details: \(error.localizedDescription)")
                    
                    await MainActor.run {
                        isGeneratingCharacter = false
                        generationError = error.localizedDescription
                        showingError = true
                        
                        // Remove the failed request
                        try? dataManager.delete(request: request)
                    }
                    
                    print("=== createCharacterWithEnhancedData END (with error) ===\n")
                }
            }
        } catch {
            print("\n❌ Failed to save request: \(error)")
            print("Error details: \(error.localizedDescription)")
            
            isGeneratingCharacter = false
            generationError = error.localizedDescription
            showingError = true
            
            print("=== createCharacterWithEnhancedData END (with error) ===\n")
        }
    }
}

// MARK: - Supporting Views
struct GenerationStatusCard: View {
    @State private var animationPhase = 0.0
    
    var body: some View {
        HStack(spacing: 16) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(animationPhase))
                    .animation(
                        .linear(duration: 2)
                        .repeatForever(autoreverses: false),
                        value: animationPhase
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Creating Character...")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("AI is generating your character's details")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .onAppear {
            animationPhase = 360
        }
    }
}

// MARK: - Haptic Feedback Helper
struct HapticFeedback {
    static func success() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}
