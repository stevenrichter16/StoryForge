//
//  RelationshipListView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

//
//  RelationshipListView.swift
//  StoryForge
//
//  List-based view of relationships as an alternative to the web
//

import SwiftUI

struct RelationshipItem: Identifiable {
    let id: String
    let relationship: CharacterRelationship
    let character: CharacterProfile
    
    init(relationship: CharacterRelationship, character: CharacterProfile) {
        self.id = relationship.id
        self.relationship = relationship
        self.character = character
    }
}

struct RelationshipListView: View {
    let profile: CharacterProfile
    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    @State private var groupByType = true
    @State private var searchText = ""
    
    // Update the relationships computed property:
    private var relationships: [RelationshipItem] {
        let allRelationships = dataManager.relationships(for: profile)
        
        return allRelationships.compactMap { relationship in
            // Determine the other character's ID
            let otherId: String
            if relationship.fromCharacterId == profile.id {
                otherId = relationship.toCharacterId
            } else {
                otherId = relationship.fromCharacterId
            }
            
            // Find the other character's profile
            guard let otherProfile = dataManager.allProfiles.first(where: { $0.id == otherId }) else {
                return nil
            }
            
            // Apply search filter if needed
            if !searchText.isEmpty {
                let matchesName = otherProfile.name.localizedCaseInsensitiveContains(searchText)
                let matchesType = relationship.relationshipType.localizedCaseInsensitiveContains(searchText)
                
                if !matchesName && !matchesType {
                    return nil
                }
            }
            
            return RelationshipItem(relationship: relationship, character: otherProfile)
        }
    }
    
    // Update the groupedRelationships computed property:
    private var groupedRelationships: [(type: String, items: [RelationshipItem])] {
        // First, create the dictionary grouping
        let grouped = Dictionary(grouping: relationships) { item in
            item.relationship.relationshipType
        }
        
        // Then sort and map to the expected format
        let sortedKeys = grouped.keys.sorted()
        
        return sortedKeys.map { key in
            (type: key, items: grouped[key] ?? [])
        }
    }
    
    // Update the body's flat list ForEach:
    var body: some View {
        NavigationStack {
            List {
                if groupByType {
                    // Grouped view
                    ForEach(groupedRelationships, id: \.type) { group in
                        relationshipSection(for: group)
                    }
                } else {
                    // Flat list view
                    ForEach(relationships) { item in
                        RelationshipRow(
                            relationship: item.relationship,
                            otherCharacter: item.character,
                            currentCharacterId: profile.id
                        )
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search relationships")
            .navigationTitle("\(profile.name)'s Relationships")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    @ViewBuilder
    private func sectionHeader(type: String, count: Int) -> some View {
        HStack {
            Label(type, systemImage: iconForRelationshipType(type))
                .foregroundColor(colorForRelationshipType(type))
            
            Spacer()
            
            Text("\(count)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Done") { dismiss() }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    withAnimation {
                        groupByType.toggle()
                    }
                } label: {
                    Label(
                        groupByType ? "Show as List" : "Group by Type",
                        systemImage: groupByType ? "list.bullet" : "square.grid.3x3"
                    )
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    @ViewBuilder
    private func relationshipSection(for group: (type: String, items: [RelationshipItem])) -> some View {
        Section {
            ForEach(group.items) { item in
                RelationshipRow(
                    relationship: item.relationship,
                    otherCharacter: item.character,
                    currentCharacterId: profile.id
                )
            }
        } header: {
            sectionHeader(type: group.type, count: group.items.count)
        }
    }
    
    private func iconForRelationshipType(_ type: String) -> String {
        switch type.lowercased() {
        case "family": return "person.2.fill"
        case "friend", "best friend": return "person.2"
        case "rival", "enemy": return "person.2.slash"
        case "mentor": return "person.fill.questionmark"
        case "student": return "studentdesk"
        case "love interest", "partner": return "heart.fill"
        case "colleague": return "briefcase"
        default: return "person.2"
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
