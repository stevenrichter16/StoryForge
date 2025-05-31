import SwiftUI

struct CharacterReviewStep: View {
    let characterData: CharacterCreationData
    let selectedTraits: [String: Set<CharacterTrait>]
    
    // Define hasTraits as a computed property
    private var hasTraits: Bool {
        selectedTraits.values.contains(where: { !$0.isEmpty })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                ReviewHeader()
                
                // Character Summary Card
                CharacterSummaryCard(
                    characterData: characterData,
                    selectedTraits: selectedTraits,
                    hasTraits: hasTraits
                )
                .padding(.horizontal)
                
                // AI Generation Preview
                AIGenerationPreview()
                    .padding(.horizontal)
                
                // Trait Summary Stats
                if hasTraits {
                    TraitSummaryCard(selectedTraits: selectedTraits)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Subcomponents
private struct ReviewHeader: View {
    var body: some View {
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
    }
}

private struct CharacterSummaryCard: View {
    let characterData: CharacterCreationData
    let selectedTraits: [String: Set<CharacterTrait>]
    let hasTraits: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Basic Info Section
            BasicInfoSection(characterData: characterData)
            
            // Traits Section
            if hasTraits {
                Divider()
                TraitsReviewSection(selectedTraits: selectedTraits)
            }
            
            // Additional Notes Section
            if !characterData.additionalNotes.isEmpty {
                Divider()
                AdditionalNotesSection(notes: characterData.additionalNotes)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

private struct BasicInfoSection: View {
    let characterData: CharacterCreationData
    
    var body: some View {
        ReviewSection(title: "Basic Information", icon: "person.fill") {
            VStack(alignment: .leading, spacing: 8) {
                ReviewRow(label: "Name", value: characterData.name)
                
                if !characterData.age.isEmpty {
                    ReviewRow(label: "Age", value: characterData.age)
                }
                
                if !characterData.occupation.isEmpty {
                    ReviewRow(label: "Occupation", value: characterData.occupation)
                }
                
                ReviewRow(
                    label: "Genre",
                    value: characterData.genre.name,
                    color: Color(hex: characterData.genre.color)
                )
                
                ReviewRow(label: "Type", value: characterData.archetype.name)
                
                ReviewRow(label: "Complexity", value: characterData.complexity.name)
            }
        }
    }
}

private struct TraitsReviewSection: View {
    let selectedTraits: [String: Set<CharacterTrait>]
    
    var body: some View {
        ReviewSection(title: "Character Traits", icon: "sparkles") {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(CharacterTraitDatabase.categories) { category in
                    if let categoryTraits = selectedTraits[category.name],
                       !categoryTraits.isEmpty {
                        CategoryTraitRow(
                            category: category,
                            traits: Array(categoryTraits)
                        )
                    }
                }
            }
        }
    }
}

private struct CategoryTraitRow: View {
    let category: CharacterTraitCategory
    let traits: [CharacterTrait]
    
    private var categoryColor: Color {
        // Match with CharacterTraitDatabase categories
        switch category.name {
        case "Physical Build": return .orange
        case "Core Personality": return .blue
        case "Social Style": return .green
        case "Moral Alignment": return .purple
        case "Notable Skills": return .yellow
        case "Background": return .brown
        case "Quirks & Flaws": return .pink
        case "Core Motivation": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Category header
            HStack {
                Image(systemName: category.icon)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            
            // Trait pills
            FlowLayout(spacing: 6) {
                ForEach(traits, id: \.id) { trait in
                    ReviewTraitPill(text: trait.name)
                }
            }
        }
    }
}

private struct AdditionalNotesSection: View {
    let notes: String
    
    var body: some View {
        ReviewSection(title: "Additional Notes", icon: "note.text") {
            Text(notes)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Simple TraitPill for Review
private struct ReviewTraitPill: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
    }
}
