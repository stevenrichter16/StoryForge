//
//  CharacterSelectionButton.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CharacterSelectionButton: View {
    let profile: CharacterProfile
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color(hex: genre?.color ?? "#808080").opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Text(profile.name.prefix(2).uppercased())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: genre?.color ?? "#808080"))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.name)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(.primary)
                    
                    Text(profile.occupation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}
