//
//  AddRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Placeholder for Add Relationship View
struct AddRelationshipView: View {
    let fromProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Add Relationship Interface")
                .navigationTitle("Add Relationship")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}

