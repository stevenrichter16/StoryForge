//
//  RelationshipViewMode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//


//
//  ViewModePicker.swift
//  StoryForge
//
//  Created by Assistant on 5/31/25.
//

import SwiftUI

// MARK: - View Mode for Relationships
enum RelationshipViewMode: String, CaseIterable {
    case cards = "Cards"
    case list = "List" 
    case web = "Web"
    
    var icon: String {
        switch self {
        case .cards: return "square.grid.2x2"
        case .list: return "list.bullet"
        case .web: return "network"
        }
    }
}

// MARK: - View Mode Picker
struct ViewModePicker: View {
    @Binding var selectedMode: RelationshipViewMode
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(RelationshipViewMode.allCases, id: \.self) { mode in
                Button(action: { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMode = mode 
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 16, weight: .medium))
                        Text(mode.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedMode == mode ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(selectedMode == mode ? Color.blue : Color(.tertiarySystemBackground))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color(.quaternarySystemFill))
        )
    }
}
