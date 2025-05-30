//
//  SelectedCharacterRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Supporting Views
struct SelectedCharacterRow: View {
    let profile: CharacterProfile
    let onRemove: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    var body: some View {
        HStack {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: genre?.color ?? "#808080").opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(profile.name.prefix(2).uppercased())
                    .font(.headline)
                    .foregroundColor(Color(hex: genre?.color ?? "#808080"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.headline)
                
                Text(profile.occupation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
