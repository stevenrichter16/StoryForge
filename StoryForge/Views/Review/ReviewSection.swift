//
//  ReviewSection.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct ReviewSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            content()
        }
    }
}
