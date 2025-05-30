//
//  CharacterDetailTabBar.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Tab Bar
struct CharacterDetailTabBar: View {
    @Binding var selectedTab: Int
    let tabs = ["Personality", "Backstory", "Relationships", "Notes"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(tabs[index])
                            .font(.subheadline)
                            .fontWeight(selectedTab == index ? .semibold : .regular)
                            .foregroundColor(selectedTab == index ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == index ? Color.blue : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}
