//
//  FullRelationshipWebView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Full Relationship Web View
struct FullRelationshipWebView: View {
    let centerProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            RelationshipWebVisualization(centerProfile: centerProfile)
                .navigationTitle("Relationship Web")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}
