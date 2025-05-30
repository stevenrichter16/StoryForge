//
//  DetailsStep.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct DetailsStep: View {
    @Binding var selectedComplexity: ComplexityLevel
    @Binding var ageRange: String
    @Binding var timePeriod: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Optional information to enrich your character")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Complexity Level
                VStack(alignment: .leading, spacing: 12) {
                    Label("Complexity Level", systemImage: "slider.horizontal.3")
                        .font(.headline)
                    
                    ForEach(ComplexityLevel.all, id: \.id) { level in
                        ComplexityCard(
                            level: level,
                            isSelected: selectedComplexity.id == level.id,
                            action: { selectedComplexity = level }
                        )
                    }
                }
                .padding(.horizontal)
                
                // Age Range
                VStack(alignment: .leading, spacing: 8) {
                    Label("Age Range (Optional)", systemImage: "calendar")
                        .font(.headline)
                    
                    TextField("e.g., 25-35, elderly, young adult", text: $ageRange)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                // Time Period
                VStack(alignment: .leading, spacing: 8) {
                    Label("Time Period (Optional)", systemImage: "clock")
                        .font(.headline)
                    
                    TextField("e.g., Victorian era, far future, 1920s", text: $timePeriod)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                // Tips
                TipsCard()
                    .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
    }
}
