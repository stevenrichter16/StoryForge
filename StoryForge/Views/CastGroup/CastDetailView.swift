//
//  CastDetailView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Cast Detail View
struct CastDetailView: View {
    let cast: Cast
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingAddCharacter = false
    @State private var selectedCharacter: CharacterProfile?
    
    private var castProfiles: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            cast.characterIds.contains(profile.id)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Cast Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(cast.castDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Label("\(cast.characterIds.count) characters", systemImage: "person.3")
                            .font(.caption)
                        
                        Spacer()
                        
                        Text("Created \(cast.createdAt.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Character Grid
                if !castProfiles.isEmpty {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(castProfiles) { profile in
                            if let request = dataManager.request(for: profile) {
                                CharacterGridCard(profile: profile, request: request)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Relationship Web
                if cast.characterIds.count > 1 {
                    CastRelationshipView(cast: cast)
                        .frame(height: 300)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(cast.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddCharacter = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCharacter) {
            AddCharacterToCastView(cast: cast)
        }
    }
}
