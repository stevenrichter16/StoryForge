//
//  DetailSection.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Component Views
struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(.primary)
            
            content()
        }
    }
}
