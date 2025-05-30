//
//  AddCastRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Add Cast Relationship View
struct AddCastRelationshipView: View {
    let cast: Cast
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    @State private var fromCharacterId = ""
    @State private var toCharacterId = ""
    @State private var relationshipType = "Friend"
    @State private var relationshipDescription = ""
    
    private var castProfiles: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            cast.characterIds.contains(profile.id)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("From Character") {
                    Picker("Select Character", selection: $fromCharacterId) {
                        Text("Select...").tag("")
                        ForEach(castProfiles) { profile in
                            Text(profile.name).tag(profile.id)
                        }
                    }
                }
                
                Section("To Character") {
                    Picker("Select Character", selection: $toCharacterId) {
                        Text("Select...").tag("")
                        ForEach(castProfiles.filter { $0.id != fromCharacterId }) { profile in
                            Text(profile.name).tag(profile.id)
                        }
                    }
                }
                
                Section("Relationship") {
                    Picker("Type", selection: $relationshipType) {
                        ForEach(["Family", "Friend", "Rival", "Mentor", "Student", "Partner"], id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    TextField("Description (optional)", text: $relationshipDescription, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Add Relationship")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addRelationship()
                    }
                    .disabled(fromCharacterId.isEmpty || toCharacterId.isEmpty)
                }
            }
        }
    }
    
    private func addRelationship() {
        let relationship = CharacterRelationship(
            fromCharacterId: fromCharacterId,
            toCharacterId: toCharacterId,
            relationshipType: relationshipType,
            characterRelationshipDescription: relationshipDescription
        )
        
        do {
            try dataManager.save(relationship: relationship)
            dismiss()
        } catch {
            print("Failed to save relationship: \(error)")
        }
    }
}
