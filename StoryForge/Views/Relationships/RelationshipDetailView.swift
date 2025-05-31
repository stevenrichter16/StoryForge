//
//  RelationshipDetailVeiw.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Relationship Detail View
//
//  RelationshipDetailView.swift
//  StoryForge
//
//  Fixed positioning bug for character circles
//

import SwiftUI

struct RelationshipDetailView: View {
    let relationship: CharacterRelationship
    let fromCharacter: CharacterProfile
    let toCharacter: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Fixed positioning - now properly centered
                    HStack(spacing: 40) {
                        CharacterCircle(profile: fromCharacter, size: 80)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundColor(.secondary)
                            
                            Text(relationship.relationshipType)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(colorForRelationshipType(relationship.relationshipType).opacity(0.2))
                                )
                        }
                        
                        CharacterCircle(profile: toCharacter, size: 80)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    
                    // Relationship details
                    if !relationship.characterRelationshipDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Description", systemImage: "text.quote")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(relationship.characterRelationshipDescription)
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Metadata
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Created", systemImage: "calendar")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(relationship.createdAt.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button {
                            // View from character
                            dismiss()
                        } label: {
                            Label("View \(fromCharacter.name)", systemImage: "person.text.rectangle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            // View to character
                            dismiss()
                        } label: {
                            Label("View \(toCharacter.name)", systemImage: "person.text.rectangle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("Relationship Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func colorForRelationshipType(_ type: String) -> Color {
        switch type.lowercased() {
        case "family": return .blue
        case "friend", "best friend": return .green
        case "rival", "enemy": return .red
        case "mentor", "student": return .purple
        case "love interest", "partner": return .pink
        case "colleague": return .orange
        default: return .gray
        }
    }
}
