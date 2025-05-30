//
//  ProgressBar.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

// MARK: - Composer Components
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var progress: Double {
        Double(currentStep + 1) / Double(totalSteps)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .cornerRadius(2)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 4)
    }
}
