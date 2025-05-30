//
//  EmptyRelationshipsView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct EmptyRelationshipsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("No relationships yet")
                .font(.headline)
            
            Text("Add connections to build your character's world")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
