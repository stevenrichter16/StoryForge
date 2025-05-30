//
//  CharacterListCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CharacterListCard: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    @State private var showingDetail = false
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 16) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color(hex: request.genre.color).opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(profile.name.prefix(2).uppercased())
                        .font(.headline)
                        .foregroundColor(Color(hex: request.genre.color))
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(profile.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if profile.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Text(profile.tagline)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Label(request.genre.name, systemImage: "books.vertical")
                            .font(.caption2)
                            .foregroundColor(Color(hex: request.genre.color))
                        
                        Label(request.archetype.name, systemImage: request.archetype.icon)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            CharacterDetailView(profile: profile, request: request)
        }
    }
}
