//
//  BackstoryView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUICore
import Foundation

// MARK: - Backstory View
struct BackstoryView: View {
    let profile: CharacterProfile
    @State private var expandedSections: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Main Backstory
            DetailSection(title: "Origin Story", icon: "book.fill") {
                Text(profile.backstory)
                    .font(.body)
                    .lineSpacing(4)
            }
            
            // Key Life Events
            if !profile.keyLifeEvents.isEmpty {
                DetailSection(title: "Key Life Events", icon: "calendar") {
                    VStack(spacing: 12) {
                        ForEach(Array(profile.keyLifeEvents.enumerated()), id: \.offset) { index, event in
                            TimelineEventCard(
                                event: event,
                                index: index,
                                isExpanded: expandedSections.contains(event),
                                onTap: {
                                    withAnimation {
                                        if expandedSections.contains(event) {
                                            expandedSections.remove(event)
                                        } else {
                                            expandedSections.insert(event)
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
            
            // Secrets
            if !profile.secrets.isEmpty {
                DetailSection(title: "Secrets", icon: "lock.fill") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(profile.secrets, id: \.self) { secret in
                            SecretCard(secret: secret)
                        }
                    }
                }
            }
            
            // Physical Description
            DetailSection(title: "Appearance", icon: "person.fill") {
                Text(profile.physicalDescription)
                    .font(.body)
                    .lineSpacing(4)
                
                if !profile.distinguishingFeatures.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Distinguishing Features")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top)
                        
                        ForEach(profile.distinguishingFeatures, id: \.self) { feature in
                            HStack {
                                Circle()
                                    .fill(Color.secondary.opacity(0.3))
                                    .frame(width: 6, height: 6)
                                Text(feature)
                                    .font(.body)
                            }
                        }
                    }
                }
            }
        }
    }
}
