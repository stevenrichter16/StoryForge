//
//  CreateCastView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CreateCastView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    @State private var castName = ""
    @State private var castDescription = ""
    @State private var selectedCharacterIds: Set<String> = []
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Cast Name", text: $castName)
                    TextField("Description", text: $castDescription, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Add Characters") {
                    if dataManager.allProfiles.isEmpty {
                        Text("No characters available")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(dataManager.allProfiles) { profile in
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
                }
            }
            .navigationTitle("New Cast")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createCast()
                    }
                    .disabled(castName.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createCast() {
        let cast = Cast(
            name: castName,
            castDescription: castDescription,
            characterIds: Array(selectedCharacterIds)
        )
        
        do {
            try dataManager.save(cast: cast)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}
