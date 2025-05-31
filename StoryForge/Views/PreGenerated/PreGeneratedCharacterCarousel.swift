//
//  PreGeneratedCharacterCarousel.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI
import Combine

// MARK: - Wrapper for sheet presentation
struct CharacterPreview: Identifiable {
    let id = UUID()
    let request: CharacterRequest
    let profile: CharacterProfile
}

// MARK: - Pregenerated Character Carousel
// MARK: - Pregenerated Character Carousel
struct PreGeneratedCharacterCarousel: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var characterService: CharacterService
    @State private var currentIndex: Int = 0
    @State private var isAutoScrolling = true
    @State private var selectedCharacterPreview: CharacterPreview?
    @State private var showingImportConfirmation = false
    @State private var characterToImport: CharacterPreview?
    @State private var timer: Timer?
    
    private let cardWidth: CGFloat = 280
    private let cardSpacing: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Explore Characters")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Tap to preview • Hold to import")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Auto-scroll toggle
                Button {
                    isAutoScrolling.toggle()
                    if isAutoScrolling {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                } label: {
                    Image(systemName: isAutoScrolling ? "pause.circle" : "play.circle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Simplified Carousel
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: cardSpacing) {
                        ForEach(Array(PreGeneratedCharacters.characters.enumerated()), id: \.offset) { index, character in
                            PreGeneratedCharacterCard(
                                request: character.request,
                                profile: character.profile,
                                onTap: {
                                    stopTimer()
                                    selectedCharacterPreview = CharacterPreview(
                                        request: character.request,
                                        profile: character.profile
                                    )
                                },
                                onLongPress: {
                                    stopTimer()
                                    characterToImport = CharacterPreview(
                                        request: character.request,
                                        profile: character.profile
                                    )
                                    showingImportConfirmation = true
                                }
                            )
                            .frame(width: cardWidth)
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onAppear {
                    if isAutoScrolling {
                        startTimer()
                    }
                }
                .onDisappear {
                    stopTimer()
                }
                .onChange(of: currentIndex) { newIndex in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
            .frame(height: 200)
        }
        .sheet(item: $selectedCharacterPreview) { preview in
            PreGeneratedCharacterDetail(
                request: preview.request,
                profile: preview.profile,
                onImport: {
                    importCharacter(preview)
                }
            )
        }
        .alert("Import Character?", isPresented: $showingImportConfirmation) {
            Button("Import") {
                if let character = characterToImport {
                    importCharacter(character)
                }
            }
            Button("Cancel", role: .cancel) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isAutoScrolling = true
                    startTimer()
                }
            }
        } message: {
            if let character = characterToImport {
                Text("Add \(character.profile.name) to your character gallery?")
            }
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            currentIndex = (currentIndex + 1) % PreGeneratedCharacters.characters.count
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func importCharacter(_ character: CharacterPreview) {
        // Create a copy with new IDs
        let newRequest = CharacterRequest(
            userPrompt: character.request.userPrompt,
            genre: character.request.genre,
            archetype: character.request.archetype,
            complexityLevel: character.request.complexityLevel,
            ageRange: character.request.ageRange,
            timePeriod: character.request.timePeriod,
            additionalTraits: character.request.additionalTraits
        )
        
        let newProfile = CharacterProfile(
            requestId: newRequest.id,
            name: character.profile.name,
            age: character.profile.age,
            occupation: character.profile.occupation,
            tagline: character.profile.tagline,
            physicalDescription: character.profile.physicalDescription,
            personalityTraits: character.profile.personalityTraits,
            backstory: character.profile.backstory
        )
        
        // Copy all the details
        newProfile.distinguishingFeatures = character.profile.distinguishingFeatures
        newProfile.coreBelief = character.profile.coreBelief
        newProfile.fears = character.profile.fears
        newProfile.desires = character.profile.desires
        newProfile.secrets = character.profile.secrets
        newProfile.motivations = character.profile.motivations
        newProfile.keyLifeEvents = character.profile.keyLifeEvents
        newProfile.internalConflict = character.profile.internalConflict
        newProfile.externalConflict = character.profile.externalConflict
        newProfile.characterArc = character.profile.characterArc
        newProfile.allSelectedTraits = character.profile.allSelectedTraits
        
        // Save to data manager
        do {
            newRequest.profileId = newProfile.id
            try dataManager.save(request: newRequest)
            try dataManager.save(profile: newProfile)
            
            // Provide feedback
            HapticFeedback.success()
            
            // Resume scrolling
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAutoScrolling = true
                startTimer()
            }
        } catch {
            print("Failed to import character: \(error)")
        }
    }
}

