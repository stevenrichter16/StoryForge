//
//  RecentCreationsSection.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Recent Creations Section
struct RecentCreationsSection: View {
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Recent Characters", systemImage: "clock.arrow.circlepath")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: GalleryView()) {
                    Text("See All")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            ForEach(dataManager.allRequests.prefix(3)) { request in
                if let profile = dataManager.profile(for: request) {
                    MiniCharacterCard(profile: profile, request: request)
                } else {
                    CharacterLoadingCard(request: request)
                }
            }
        }
    }
}

