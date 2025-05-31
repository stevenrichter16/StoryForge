//
//  GraphNode.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import Foundation

// MARK: - Graph Node Model
struct GraphNode: Identifiable {
    let id = UUID()
    let profileId: String
    var position: CGPoint
    var velocity: CGPoint
    let radius: CGFloat
    let isFixed: Bool
    
    init(profileId: String, position: CGPoint, velocity: CGPoint = .zero, radius: CGFloat = 25, isFixed: Bool = false) {
        self.profileId = profileId
        self.position = position
        self.velocity = velocity
        self.radius = radius
        self.isFixed = isFixed
    }
}
