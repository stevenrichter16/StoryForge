//
//  EmptyGalleryView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Empty States
struct EmptyGalleryView: View {
    let hasSearch: Bool
    let filter: GalleryView.FilterOption
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: hasSearch ? "magnifyingglass" : "person.3.slash")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text(hasSearch ? "No characters found" : emptyMessage)
                .font(.headline)
            
            Text(hasSearch ? "Try adjusting your search" : "Create your first character to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyMessage: String {
        switch filter {
        case .all:
            return "No characters yet"
        case .byGenre:
            return "No characters in this genre"
        case .byArchetype:
            return "No characters of this type"
        case .recent:
            return "No recent characters"
        case .favorites:
            return "No favorite characters"
        }
    }
}
