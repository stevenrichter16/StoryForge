//
//  MiniCharacterCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct MiniCharacterCard: View {
    let profile: CharacterProfile
    let request: CharacterRequest
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color(hex: request.genre.color).opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Text(profile.name.prefix(2).uppercased())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: request.genre.color))
                }
                
                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("\(request.genre.name) • \(request.archetype.name)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Time
                Text(request.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            CharacterDetailView(profile: profile, request: request)
        }
    }
}
