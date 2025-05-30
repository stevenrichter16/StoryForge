//
//  NavigationButtons.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Supporting Components
struct NavigationButtons: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    let canProceed: Bool
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation {
                        currentStep -= 1
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            
            Button(currentStep == totalSteps - 1 ? "Create Character" : "Next") {
                if currentStep == totalSteps - 1 {
                    onComplete()
                } else {
                    withAnimation {
                        currentStep += 1
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(canProceed ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(!canProceed)
        }
        .padding()
    }
}
