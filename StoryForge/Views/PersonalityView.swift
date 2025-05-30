//
//  PersonalityView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Personality View
struct PersonalityView: View {
    let profile: CharacterProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Personality Traits
            DetailSection(title: "Personality Traits", icon: "sparkles") {
                FlowLayout(spacing: 8) {
                    ForEach(profile.personalityTraits, id: \.self) { trait in
                        TraitChip(trait: trait, color: .blue)
                    }
                }
            }
            
            // Core Belief
            if !profile.coreBelief.isEmpty {
                DetailSection(title: "Core Belief", icon: "heart.circle") {
                    Text(profile.coreBelief)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            // Desires
            if !profile.desires.isEmpty {
                DetailSection(title: "Desires", icon: "star") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(profile.desires, id: \.self) { desire in
                            HStack(alignment: .top) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                Text(desire)
                                    .font(.body)
                            }
                        }
                    }
                }
            }
            
            // Fears
            if !profile.fears.isEmpty {
                DetailSection(title: "Fears", icon: "exclamationmark.triangle") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(profile.fears, id: \.self) { fear in
                            HStack(alignment: .top) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text(fear)
                                    .font(.body)
                            }
                        }
                    }
                }
            }
            
            // Conflicts
            DetailSection(title: "Conflicts", icon: "bolt") {
                VStack(alignment: .leading, spacing: 16) {
                    ConflictCard(
                        title: "Internal Conflict",
                        content: profile.internalConflict,
                        color: .purple
                    )
                    
                    ConflictCard(
                        title: "External Conflict",
                        content: profile.externalConflict,
                        color: .orange
                    )
                }
            }
        }
        .onAppear {
            print("=== PersonalityView Display Debug ===")
            print("Profile name: \(profile.name)")
            print("Personality traits count: \(profile.personalityTraits.count)")
            print("Personality traits: \(profile.personalityTraits)")
            print("===================================")
        }
    }
}
