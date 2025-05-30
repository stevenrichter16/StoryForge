//
//  AddRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Placeholder for Add Relationship View
struct AddRelationshipView: View {
    let fromProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    @State private var selectedCharacterId: String = ""
    @State private var relationshipType: RelationshipType = .friend
    @State private var relationshipDescription = ""
    @State private var isBidirectional = false
    @State private var searchText = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    enum RelationshipType: String, CaseIterable {
        case family = "Family"
        case friend = "Friend"
        case bestFriend = "Best Friend"
        case rival = "Rival"
        case enemy = "Enemy"
        case mentor = "Mentor"
        case student = "Student"
        case loveInterest = "Love Interest"
        case partner = "Partner"
        case colleague = "Colleague"
        case acquaintance = "Acquaintance"
        
        var icon: String {
            switch self {
            case .family: return "person.2.fill"
            case .friend, .bestFriend: return "person.2"
            case .rival, .enemy: return "person.2.slash"
            case .mentor: return "person.fill.questionmark"
            case .student: return "studentdesk"
            case .loveInterest, .partner: return "heart.fill"
            case .colleague: return "briefcase"
            case .acquaintance: return "person.crop.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .family: return .blue
            case .friend, .bestFriend: return .green
            case .rival, .enemy: return .red
            case .mentor, .student: return .purple
            case .loveInterest, .partner: return .pink
            case .colleague: return .orange
            case .acquaintance: return .gray
            }
        }
    }
    
    private var availableCharacters: [CharacterProfile] {
        dataManager.allProfiles
            .filter { $0.id != fromProfile.id }
            .filter { profile in
                if searchText.isEmpty { return true }
                return profile.name.localizedCaseInsensitiveContains(searchText) ||
                       profile.occupation.localizedCaseInsensitiveContains(searchText)
            }
    }
    
    private var selectedCharacter: CharacterProfile? {
        dataManager.allProfiles.first { $0.id == selectedCharacterId }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Character Selection
                Section {
                    if let selected = selectedCharacter {
                        SelectedCharacterRow(
                            profile: selected,
                            onRemove: { selectedCharacterId = "" }
                        )
                    } else {
                        SearchableCharacterList(
                            characters: availableCharacters,
                            searchText: $searchText,
                            selectedId: $selectedCharacterId
                        )
                    }
                } header: {
                    Label("Select Character", systemImage: "person.crop.circle")
                }
                
                // Relationship Type
                Section {
                    Picker("Relationship Type", selection: $relationshipType) {
                        ForEach(RelationshipType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    // Visual indicator
                    HStack {
                        CharacterBadge(profile: fromProfile)
                        
                        Image(systemName: isBidirectional ? "arrow.left.arrow.right" : "arrow.right")
                            .font(.title3)
                            .foregroundColor(relationshipType.color)
                        
                        if let selected = selectedCharacter {
                            CharacterBadge(profile: selected)
                        } else {
                            Circle()
                                .fill(Color(.tertiarySystemBackground))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill.questionmark")
                                        .foregroundColor(.secondary)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                } header: {
                    Label("Relationship Details", systemImage: "arrow.triangle.2.circlepath")
                }
                
                // Description
                Section {
                    TextField("Describe the relationship...", text: $relationshipDescription, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Label("Description (Optional)", systemImage: "text.quote")
                }
                
                // Options
                Section {
                    Toggle("Bidirectional Relationship", isOn: $isBidirectional)
                        .help("Creates a reciprocal relationship from both characters")
                    
                    if isBidirectional {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                            
                            Text("This will create relationships in both directions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Label("Options", systemImage: "gearshape")
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
                    .fontWeight(.semibold)
                    .disabled(selectedCharacterId.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addRelationship() {
        guard !selectedCharacterId.isEmpty else { return }
        
        // Create primary relationship
        let relationship = CharacterRelationship(
            fromCharacterId: fromProfile.id,
            toCharacterId: selectedCharacterId,
            relationshipType: relationshipType.rawValue,
            characterRelationshipDescription: relationshipDescription
        )
        
        do {
            try dataManager.save(relationship: relationship)
            
            // Create bidirectional relationship if requested
            if isBidirectional {
                let reciprocalRelationship = CharacterRelationship(
                    fromCharacterId: selectedCharacterId,
                    toCharacterId: fromProfile.id,
                    relationshipType: relationshipType.rawValue,
                    characterRelationshipDescription: relationshipDescription
                )
                try dataManager.save(relationship: reciprocalRelationship)
            }
            
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}
