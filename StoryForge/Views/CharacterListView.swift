//
//  CharacterListView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Character List View
struct CharacterListView: View {
    let profiles: [CharacterProfile]
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(profiles) { profile in
                    if let request = dataManager.request(for: profile) {
                        CharacterListCard(profile: profile, request: request)
                    }
                }
            }
            .padding()
        }
    }
}
