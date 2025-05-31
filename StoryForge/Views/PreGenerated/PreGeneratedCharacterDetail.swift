//
//  PreGeneratedCharacterDetail.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI

// MARK: - Character Detail Sheet
struct PreGeneratedCharacterDetail: View {
    let request: CharacterRequest
    let profile: CharacterProfile
    let onImport: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero section
                    CharacterHeroHeader(profile: profile, request: request)
                    
                    // Tab bar
                    CharacterDetailTabBar(selectedTab: $selectedTab)
                        .padding(.top)
                    
                    // Content
                    Group {
                        switch selectedTab {
                        case 0:
                            PersonalityView(profile: profile)
                        case 1:
                            AllTraitsView(profile: profile)
                        case 2:
                            BackstoryView(profile: profile)
                        case 3:
                            VStack(spacing: 16) {
                                Image(systemName: "lock.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("Import to view relationships")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 200)
                        case 4:
                            StoryNotesView(profile: profile)
                        default:
                            PersonalityView(profile: profile)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Preview Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onImport()
                        dismiss()
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}
