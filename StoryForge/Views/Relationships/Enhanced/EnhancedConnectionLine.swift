//
//  EnhancedConnectionLine.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//


//
//  EnhancedConnectionLine.swift
//  StoryForge
//
//  Created by Assistant on 5/31/25.
//

import SwiftUI

// MARK: - Enhanced Connection Line
struct EnhancedConnectionLine: View {
    let relationship: CharacterRelationship
    let from: CGPoint
    let to: CGPoint
    let isHighlighted: Bool
    let zoom: CGFloat
    
    @State private var animationProgress: CGFloat = 0
    
    private var connectionColor: Color {
        switch relationship.relationshipType.lowercased() {
        case "family": return .blue
        case "friend", "best friend": return .green
        case "rival", "enemy": return .red
        case "mentor", "student": return .purple
        case "love interest", "partner": return .pink
        case "colleague": return .orange
        default: return .gray
        }
    }
    
    private var lineWidth: CGFloat {
        let baseWidth: CGFloat = isHighlighted ? 4 : 2
        return baseWidth / zoom
    }
    
    var body: some View {
        ZStack {
            // Main connection line
            Path { path in
                path.move(to: from)
                
                // Create smooth curve
                let distance = sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
                let controlOffset = distance * 0.2
                let midPoint = CGPoint(
                    x: (from.x + to.x) / 2,
                    y: (from.y + to.y) / 2
                )
                
                // Perpendicular offset for curve
                let perpX = -(to.y - from.y) / distance * controlOffset
                let perpY = (to.x - from.x) / distance * controlOffset
                
                path.addQuadCurve(
                    to: to,
                    control: CGPoint(x: midPoint.x + perpX, y: midPoint.y + perpY)
                )
            }
            .stroke(
                connectionColor.opacity(isHighlighted ? 0.9 : 0.6),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            
            // Animated flow for highlighted connections
            if isHighlighted {
                Path { path in
                    path.move(to: from)
                    let distance = sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
                    let controlOffset = distance * 0.2
                    let midPoint = CGPoint(
                        x: (from.x + to.x) / 2,
                        y: (from.y + to.y) / 2
                    )
                    let perpX = -(to.y - from.y) / distance * controlOffset
                    let perpY = (to.x - from.x) / distance * controlOffset
                    
                    path.addQuadCurve(
                        to: to,
                        control: CGPoint(x: midPoint.x + perpX, y: midPoint.y + perpY)
                    )
                }
                .trim(from: max(0, animationProgress - 0.3), to: animationProgress)
                .stroke(
                    connectionColor,
                    style: StrokeStyle(lineWidth: lineWidth + 2, lineCap: .round)
                )
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        animationProgress = 1.3
                    }
                }
            }
            
            // Relationship type label (for highlighted connections)
            if isHighlighted {
                Text(relationship.relationshipType)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(connectionColor.opacity(0.8))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    )
                    .position(
                        x: (from.x + to.x) / 2,
                        y: (from.y + to.y) / 2
                    )
                    .scaleEffect(1.0 / zoom)
            }
        }
    }
}
