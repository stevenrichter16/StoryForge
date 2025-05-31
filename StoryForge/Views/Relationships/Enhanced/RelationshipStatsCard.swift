//
//  RelationshipStatsCard.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//


//
//  RelationshipStatsCard.swift
//  StoryForge
//
//  Created by Assistant on 5/31/25.
//

import SwiftUI

// MARK: - Relationship Stats Card
struct RelationshipStatsCard: View {
    let totalConnections: Int
    let twoWayConnections: Int
    let closeConnections: Int
    let rivalConnections: Int
    
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
            
            if rivalConnections > 0 {
                Divider()
                    .frame(height: 40)
                
                StatItem(
                    icon: "person.2.slash",
                    value: "\(rivalConnections)",
                    label: "Rivals",
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}

// MARK: - Stat Item Component
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
