//
//  AddCharacterToCastView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct AddCharacterToCastView: View {
    let cast: Cast
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    @State private var selectedCharacterIds: Set<String> = []
    @State private var showingError = false
    @State private var errorMessage = ""
    
    // Get available characters (not already in this cast)
    private var availableCharacters: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            !cast.characterIds.contains(profile.id)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if availableCharacters.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        
                        Text("No Available Characters")
                            .font(.headline)
                        
                        Text("All characters are already in this cast")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Character selection list
                    List {
                        ForEach(availableCharacters) { profile in
                            CharacterSelectionRow(
                                profile: profile,
                                isSelected: selectedCharacterIds.contains(profile.id),
                                action: {
                                    if selectedCharacterIds.contains(profile.id) {
                                        selectedCharacterIds.remove(profile.id)
                                    } else {
                                        selectedCharacterIds.insert(profile.id)
                                    }
                                }
                            )
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Add to \(cast.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addCharactersToCast()
                    }
                    .fontWeight(.semibold)
                    .disabled(selectedCharacterIds.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addCharactersToCast() {
        // Add selected characters to the cast
        cast.characterIds.append(contentsOf: selectedCharacterIds)
        
        do {
            try dataManager.update(cast: cast)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}
