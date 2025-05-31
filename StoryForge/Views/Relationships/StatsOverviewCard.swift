//
//  StatsOverviewCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI

// MARK: - Stats Overview Card
struct StatsOverviewCard: View {
    let totalConnections: Int
    let twoWayConnections: Int
    let closeConnections: Int
    
    var body: some View {
        HStack(spacing: 0) {
            StatItem(
                icon: "person.2.fill",
                value: "\(totalConnections)",
                label: "Total",
                color: .blue
            )
            
            Divider()
                .frame(height: 40)
            
            StatItem(
                icon: "arrow.left.arrow.right",
                value: "\(twoWayConnections)",
                label: "Mutual",
                color: .green
            )
            
            Divider()
                .frame(height: 40)
            
            StatItem(
                icon: "heart.fill",
                value: "\(closeConnections)",
                label: "Close",
                color: .red
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}
