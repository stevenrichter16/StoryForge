//
//  FavoritesView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var searchText = ""
    
    private var favoriteProfiles: [CharacterProfile] {
        let favorites = dataManager.favoriteProfiles()
        
        if searchText.isEmpty {
            return favorites
        } else {
            return favorites.filter { profile in
                profile.name.localizedCaseInsensitiveContains(searchText) ||
                profile.occupation.localizedCaseInsensitiveContains(searchText) ||
                profile.tagline.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                if favoriteProfiles.isEmpty && searchText.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Tap the heart icon on any character to add them to your favorites")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        NavigationLink(destination: GalleryView()) {
                            Label("Browse Characters", systemImage: "square.grid.2x2")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                } else {
                    ScrollView {
                        if favoriteProfiles.isEmpty {
                            // No search results
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                
                                Text("No favorites match '\(searchText)'")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(favoriteProfiles) { profile in
                                    if let request = dataManager.request(for: profile) {
                                        FavoriteCharacterCard(
                                            profile: profile,
                                            request: request
                                        )
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search favorites")
        }
    }
}

// MARK: - Favorite Character Card
struct FavoriteCharacterCard: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 16) {
                // Avatar with heart overlay
                ZStack(alignment: .topTrailing) {
                    Circle()
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
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(profile.name.prefix(2).uppercased())
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: request.genre.color))
                        )
                    
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(4)
                        .background(Circle().fill(.white))
                        .offset(x: 5, y: -5)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(profile.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(profile.tagline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label(request.genre.name, systemImage: "books.vertical")
                            .font(.caption)
                            .foregroundColor(Color(hex: request.genre.color))
                        
                        Label(request.archetype.name, systemImage: request.archetype.icon)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                unfavorite()
            } label: {
                Label("Remove from Favorites", systemImage: "heart.slash")
            }
            
            Divider()
            
            Button {
                showingDetail = true
            } label: {
                Label("View Full Profile", systemImage: "person.text.rectangle")
            }
        }
        .sheet(isPresented: $showingDetail) {
            CharacterDetailView(profile: profile, request: request)
        }
    }
    
    private func unfavorite() {
        do {
            try dataManager.toggleFavorite(for: profile)
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
    }
}
