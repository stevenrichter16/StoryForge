//
//  EmptyCastView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct EmptyCastView: View {
    @Binding var showingCreateCast: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.slash")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("No casts yet")
                .font(.headline)
            
            Text("Group related characters into casts")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button {
                showingCreateCast = true
            } label: {
                Label("Create Cast", systemImage: "plus.circle.fill")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
