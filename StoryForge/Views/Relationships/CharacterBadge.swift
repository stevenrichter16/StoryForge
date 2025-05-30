//
//  CharacterBadge.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct CharacterBadge: View {
    let profile: CharacterProfile
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color(hex: genre?.color ?? "#808080").opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(profile.name.prefix(2).uppercased())
                    .font(.headline)
                    .foregroundColor(Color(hex: genre?.color ?? "#808080"))
            }
            
            Text(profile.name)
                .font(.caption2)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}
