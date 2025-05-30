//
//  MotivationCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct MotivationCard: View {
    let motivation: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "arrow.forward.circle.fill")
                .foregroundColor(.orange)
                .font(.body)
            
            Text(motivation)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}
