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
                            AllTraitsView(profile: profile)
                        case 2:
                            BackstoryView(profile: profile)
                        case 3:
                            RelationshipsView(profile: profile)
                        case 4:
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
                            shareCharacter()
                        } label: {
                            Label("Share", systemImage: "person.crop.circle.badge.plus")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            deleteCharacter()
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
    
    private func shareCharacter() {
        // TODO: Implement share functionality
        let activityItems = [
            "Check out my character: \(profile.name)",
            "\(profile.tagline)",
            "Created with StoryForge"
        ]
        
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
    
    private func deleteCharacter() {
        do {
            // Delete the profile
            try dataManager.delete(profile: profile)
            
            // Delete the associated request if needed
            if let request = dataManager.request(for: profile) {
                try dataManager.delete(request: request)
            }
            
            dismiss()
        } catch {
            print("Failed to delete character: \(error)")
        }
    }
}


