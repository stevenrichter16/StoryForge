//
//  CharacterDetailView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    @State private var selectedTab = 0
    @State private var showingRelationshipCreator = false
    @State private var showingExportOptions = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Header
                    CharacterHeroHeader(profile: profile, request: request)
                    
                    // Tab Selection
                    CharacterDetailTabBar(selectedTab: $selectedTab)
                        .padding(.top)
                    
                    // Tab Content
                    Group {
                        switch selectedTab {
                        case 0:
                            PersonalityView(profile: profile)
                        case 1:
                            BackstoryView(profile: profile)
                        case 2:
                            RelationshipsView(profile: profile)
                        case 3:
                            StoryNotesView(profile: profile)
                        default:
                            PersonalityView(profile: profile)
                        }
                    }
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            toggleFavorite()
                        } label: {
                            Label(
                                profile.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                systemImage: profile.isFavorite ? "heart.slash" : "heart"
                            )
                        }
                        
                        Button {
                            showingExportOptions = true
                        } label: {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            // Share action
                        } label: {
                            Label("Share", systemImage: "person.crop.circle.badge.plus")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            // Delete action
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingRelationshipCreator) {
                Text("Relationship Creator")
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsView(profile: profile)
            }
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
