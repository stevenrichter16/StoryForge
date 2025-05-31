//
//  CastRelationshipListView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CastRelationshipListView: View {
    let cast: Cast
    let profiles: [CharacterProfile]
    let relationships: [CharacterRelationship]
    @EnvironmentObject private var dataManager: DataManager
    @State private var groupByCharacter = true
    @State private var searchText = ""
    
    private var filteredRelationships: [(relationship: CharacterRelationship, from: CharacterProfile, to: CharacterProfile)] {
        relationships.compactMap { relationship in
            guard let fromProfile = profiles.first(where: { $0.id == relationship.fromCharacterId }),
                  let toProfile = profiles.first(where: { $0.id == relationship.toCharacterId }) else {
                return nil
            }
            
            if searchText.isEmpty ||
               fromProfile.name.localizedCaseInsensitiveContains(searchText) ||
               toProfile.name.localizedCaseInsensitiveContains(searchText) ||
               relationship.relationshipType.localizedCaseInsensitiveContains(searchText) {
                return (relationship, fromProfile, toProfile)
            }
            
            return nil
        }
    }
    
    var body: some View {
        List {
            if groupByCharacter {
                ForEach(profiles) { profile in
                    let profileRelationships = filteredRelationships.filter { item in
                        item.from.id == profile.id || item.to.id == profile.id
                    }
                    
                    if !profileRelationships.isEmpty {
                        Section {
                            ForEach(profileRelationships, id: \.relationship.id) { item in
                                CastRelationshipRow(
                                    relationship: item.relationship,
                                    fromProfile: item.from,
                                    toProfile: item.to,
                                    viewingProfile: profile
                                )
                            }
                        } header: {
                            HStack {
                                if let request = dataManager.request(for: profile) {
                                    Circle()
                                        .fill(Color(hex: request.genre.color).opacity(0.2))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text(profile.name.prefix(2).uppercased())
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(hex: request.genre.color))
                                        )
                                }
                                
                                Text(profile.name)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text("\(profileRelationships.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            } else {
                ForEach(filteredRelationships, id: \.relationship.id) { item in
                    CastRelationshipRow(
                        relationship: item.relationship,
                        fromProfile: item.from,
                        toProfile: item.to,
                        viewingProfile: nil
                    )
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search relationships")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        groupByCharacter.toggle()
                    }
                } label: {
                    Image(systemName: groupByCharacter ? "person.3.sequence" : "list.bullet")
                }
            }
        }
    }
}
