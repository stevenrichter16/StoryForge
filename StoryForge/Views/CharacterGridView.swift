//
//  CharacterGridView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Character Grid View
struct CharacterGridView: View {
    let profiles: [CharacterProfile]
    @EnvironmentObject private var dataManager: DataManager
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(profiles) { profile in
                    if let request = dataManager.request(for: profile) {
                        CharacterGridCard(profile: profile, request: request)
                    }
                }
            }
            .padding()
        }
    }
}
