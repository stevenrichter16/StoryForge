//
//  CharacterComposerView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

// MARK: - CharacterComposerView.swift
import SwiftUI

struct CharacterComposerView: View {
    @Binding var selectedGenre: Genre
    @Binding var selectedArchetype: CharacterArchetype
    @Binding var selectedComplexity: ComplexityLevel
    let onSubmit: (CharacterCreationData) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var selectedTraits: [String: Set<CharacterTrait>] = [:]
    @State private var characterName = ""
    @State private var characterAge = ""
    @State private var characterOccupation = ""
    @State private var additionalNotes = ""
    
    private let steps = ["Basics", "Traits", "Details", "Review"]
    
    init(selectedGenre: Binding<Genre>,
         selectedArchetype: Binding<CharacterArchetype>,
         selectedComplexity: Binding<ComplexityLevel>,
         onSubmit: @escaping (CharacterCreationData) -> Void) {
        self._selectedGenre = selectedGenre
        self._selectedArchetype = selectedArchetype
        self._selectedComplexity = selectedComplexity
        self.onSubmit = onSubmit
        
        // Initialize empty trait sets for each category
        var initialTraits: [String: Set<CharacterTrait>] = [:]
        for category in CharacterTraitDatabase.categories {
            initialTraits[category.name] = []
        }
        self._selectedTraits = State(initialValue: initialTraits)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Indicator
                ProgressBar(currentStep: currentStep, totalSteps: steps.count)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Step Content
                TabView(selection: $currentStep) {
                    // Step 1: Basic Info
                    BasicCharacterInfoStep(
                        selectedGenre: $selectedGenre,
                        selectedArchetype: $selectedArchetype,
                        selectedComplexity: $selectedComplexity,
                        characterName: $characterName,
                        characterAge: $characterAge,
                        characterOccupation: $characterOccupation
                    )
                    .tag(0)
                    
                    // Step 2: Trait Selection
                    TraitSelectionStep(selectedTraits: $selectedTraits)
                    .tag(1)
                    
                    // Step 3: Additional Details
                    AdditionalDetailsStep(
                        additionalNotes: $additionalNotes,
                        selectedGenre: selectedGenre
                    )
                    .tag(2)
                    
                    // Step 4: Review
                    CharacterReviewStep(
                        characterData: buildCharacterData(),
                        selectedTraits: selectedTraits
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
                
                // Navigation Buttons
                NavigationButtons(
                    currentStep: $currentStep,
                    totalSteps: steps.count,
                    canProceed: canProceed,
                    onComplete: createCharacter
                )
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Create Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0: // Basics
            return !characterName.isEmpty
        case 1: // Traits
            // Check if required categories have selections
            for category in CharacterTraitDatabase.categories where category.isRequired {
                if selectedTraits[category.name]?.isEmpty ?? true {
                    return false
                }
            }
            return true
        case 2, 3: // Details & Review
            return true
        default:
            return false
        }
    }
    
    private func buildCharacterData() -> CharacterCreationData {
        CharacterCreationData(
            name: characterName,
            age: characterAge,
            occupation: characterOccupation,
            genre: selectedGenre,
            archetype: selectedArchetype,
            complexity: selectedComplexity,
            traits: selectedTraits,
            additionalNotes: additionalNotes
        )
    }
    
    private func createCharacter() {
        onSubmit(buildCharacterData())
    }
    
}


