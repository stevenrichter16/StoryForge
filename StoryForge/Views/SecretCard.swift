//
//  SecretCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct SecretCard: View {
    let secret: String
    @State private var isRevealed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: isRevealed ? "lock.open.fill" : "lock.fill")
                    .foregroundColor(isRevealed ? .orange : .gray)
                
                if isRevealed {
                    Text(secret)
                        .font(.body)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    Text("Tap to reveal secret")
                        .font(.body)
                        .italic()
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isRevealed.toggle()
            }
        }
    }
}
