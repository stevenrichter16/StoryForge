//
//  AdditionalDetailStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Additional Details Step
struct AdditionalDetailsStep: View {
    @Binding var additionalNotes: String
    let selectedGenre: Genre
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Any specific details or backstory elements")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Genre-specific prompts
                VStack(alignment: .leading, spacing: 12) {
                    Label("Consider including:", systemImage: "lightbulb")
                        .font(.headline)
                    
                    ForEach(genreSpecificPrompts, id: \.self) { prompt in
                        HStack(alignment: .top) {
                            Circle()
                                .fill(Color(hex: selectedGenre.color))
                                .frame(width: 6, height: 6)
                                .offset(y: 6)
                            
                            Text(prompt)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Notes Field
                VStack(alignment: .leading, spacing: 8) {
                    Label("Additional Notes", systemImage: "note.text")
                        .font(.headline)
                    
                    TextEditor(text: $additionalNotes)
                        .padding(8)
                        .frame(minHeight: 150)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            Group {
                                if additionalNotes.isEmpty {
                                    Text("Add any specific details, relationships, or story elements...")
                                        .foregroundColor(.secondary)
                                        .padding(12)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
    }
    
    private var genreSpecificPrompts: [String] {
        switch selectedGenre.name.lowercased() {
        case "fantasy":
            return [
                "Magical abilities or limitations",
                "Relationship with magic/supernatural",
                "Quest or destiny",
                "Mythical connections"
            ]
        case "sci-fi":
            return [
                "Technology expertise or augmentations",
                "Planet/colony of origin",
                "Relationship with AI/aliens",
                "Scientific specialization"
            ]
        case "mystery":
            return [
                "Investigative methods",
                "Dark secrets or past cases",
                "Unique deductive abilities",
                "Personal stakes in mysteries"
            ]
        case "historical":
            return [
                "Historical period specifics",
                "Social class and customs",
                "Historical events witnessed",
                "Period-appropriate skills"
            ]
        case "contemporary":
            return [
                "Modern profession details",
                "Social media presence",
                "Current life challenges",
                "Contemporary relationships"
            ]
        case "horror":
            return [
                "Fears and phobias",
                "Supernatural encounters",
                "Survival skills",
                "Mental fortitude"
            ]
        default:
            return [
                "Unique abilities",
                "Key relationships",
                "Personal goals",
                "Hidden secrets"
            ]
        }
    }
}
