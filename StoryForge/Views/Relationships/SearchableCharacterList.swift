//
//  SearchableCharacterList.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct SearchableCharacterList: View {
    let characters: [CharacterProfile]
    @Binding var searchText: String
    @Binding var selectedId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search characters...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(8)
            
            // Character list
            if characters.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        
                        Text("No characters found")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(characters) { profile in
                            CharacterSelectionButton(
                                profile: profile,
                                isSelected: selectedId == profile.id,
                                action: { selectedId = profile.id }
                            )
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
    }
}
