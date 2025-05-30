//
//  CastCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct CastCard: View {
    let cast: Cast
    @Binding var selectedCast: Cast?
    @EnvironmentObject private var dataManager: DataManager
    
    private var castProfiles: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            cast.characterIds.contains(profile.id)
        }
    }
    
    var body: some View {
        Button {
            selectedCast = cast
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cast.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(cast.characterIds.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                
                // Description
                if !cast.castDescription.isEmpty {
                    Text(cast.castDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Character Preview
                if !castProfiles.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -10) {
                            ForEach(castProfiles.prefix(5)) { profile in
                                if let request = dataManager.request(for: profile) {
                                    CharacterAvatarView(
                                        profile: profile,
                                        genre: request.genre,
                                        size: 40
                                    )
                                }
                            }
                            
                            if cast.characterIds.count > 5 {
                                ZStack {
                                    Circle()
                                        .fill(Color(.tertiarySystemBackground))
                                        .frame(width: 40, height: 40)
                                    
                                    Text("+\(cast.characterIds.count - 5)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}
