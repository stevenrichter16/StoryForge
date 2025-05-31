//
//  CharacterCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

import SwiftUI

struct CharacterCard: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    @EnvironmentObject private var dataManager: DataManager
    @State private var isExpanded = false
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(profile.occupation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: { toggleFavorite() }) {
                        Image(systemName: profile.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(profile.isFavorite ? .red : .secondary)
                    }
                    
                    Menu {
                        Button("View Full Profile", systemImage: "person.text.rectangle") {
                            showingDetail = true
                        }
                        
                        Button("Edit", systemImage: "pencil") {
                            // Edit action
                        }
                        
                        Button("Share", systemImage: "square.and.arrow.up") {
                            // Share action
                        }
                        
                        Divider()
                        
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            // Delete action
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Tagline
            Text(profile.tagline)
                .font(.body)
                .foregroundColor(.primary)
                .italic()
                .lineLimit(2)
            
            // Genre and Archetype badges
            HStack(spacing: 8) {
                Badge(text: request.genre.name, color: Color(hex: request.genre.color))
                Badge(text: request.archetype.name, color: .secondary)
                
                if let age = profile.age {
                    Badge(text: "Age \(age)", color: .blue.opacity(0.7))
                }
            }
            
            // Personality traits
            if !profile.personalityTraits.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(profile.personalityTraits.prefix(5), id: \.self) { trait in
                        TraitPill(text: trait, color: .blue)
                    }
                }
            }
            
            // Expandable backstory preview
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Backstory")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(profile.backstory)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                    
                    Button("View Full Profile") {
                        showingDetail = true
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }
        .sheet(isPresented: $showingDetail) {
            CharacterDetailView(profile: profile, request: request)
        }
    }
    
    private func toggleFavorite() {
        do {
            try dataManager.toggleFavorite(for: profile)
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }
}
