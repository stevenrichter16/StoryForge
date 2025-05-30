//
//  CharacterGridCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CharacterGridCard: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Character Visual
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: request.genre.color).opacity(0.3),
                                    Color(hex: request.genre.color).opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 140)
                    
                    VStack {
                        Text(profile.name.prefix(2).uppercased())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: request.genre.color))
                        
                        Image(systemName: request.archetype.icon)
                            .font(.title2)
                            .foregroundColor(Color(hex: request.genre.color).opacity(0.7))
                    }
                    
                    // Favorite indicator
                    if profile.isFavorite {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(8)
                                    .background(Circle().fill(.white))
                                    .shadow(radius: 2)
                            }
                            Spacer()
                        }
                        .padding(8)
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(profile.occupation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    // Tags
                    HStack(spacing: 4) {
                        TagView(text: request.genre.name, color: Color(hex: request.genre.color))
                        TagView(text: request.archetype.name, color: .secondary)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            CharacterDetailView(profile: profile, request: request)
        }
    }
}
