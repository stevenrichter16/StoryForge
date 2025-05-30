//
//  TipsCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct TipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Pro Tips", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 8) {
                TipRow(text: "Higher complexity = more detailed backstory")
                TipRow(text: "Age and period help with authentic details")
                TipRow(text: "Leave fields blank for AI to decide")
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}
