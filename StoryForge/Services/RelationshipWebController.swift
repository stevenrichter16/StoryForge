//
//  RelationshipWebController.swift
//  StoryForge
//
//  Force-directed layout controller for relationship visualization
//

import SwiftUI
import Combine
import SwiftData

@MainActor
class RelationshipWebController: ObservableObject {
    @Published var nodes: [GraphNode] = []
    @Published var relationships: [CharacterRelationship] = []
    
    private var centerProfileId: String = ""
    private var viewSize: CGSize = .zero
    private var simulationTimer: Timer?
    private var iterationCount = 0
    private let maxIterations = 300
    
    // Force simulation parameters
    private let linkDistance: CGFloat = 100
    private let linkStrength: CGFloat = 0.5
    private let repulsionStrength: CGFloat = -300
    private let centerStrength: CGFloat = 0.1
    private let damping: CGFloat = 0.9
    private let minVelocity: CGFloat = 0.001
    
    func initialize(centerProfile: CharacterProfile, dataManager: DataManager, viewSize: CGSize) {
        self.centerProfileId = centerProfile.id
        self.viewSize = viewSize
        
        // Build graph from relationships
        buildGraph(centerProfile: centerProfile, dataManager: dataManager)
        
        // Start force simulation
        startSimulation()
    }
    
    func getVisibleProfiles(for centerProfile: CharacterProfile, dataManager: DataManager) -> [CharacterProfile] {
        var visibleProfileIds = Set<String>()
        visibleProfileIds.insert(centerProfile.id)
        
        // Get all relationships for center profile
        let centerRelationships = dataManager.relationships(for: centerProfile)
        
        // Add directly connected profiles
        for relationship in centerRelationships {
            if relationship.fromCharacterId == centerProfile.id {
                visibleProfileIds.insert(relationship.toCharacterId)
            } else {
                visibleProfileIds.insert(relationship.fromCharacterId)
            }
        }
        
        // For each connected profile, get their relationships (second degree)
        let connectedProfileIds = visibleProfileIds.filter { $0 != centerProfile.id }
        for profileId in connectedProfileIds {
            if let profile = dataManager.allProfiles.first(where: { $0.id == profileId }) {
                let secondDegreeRelationships = dataManager.relationships(for: profile)
                for relationship in secondDegreeRelationships {
                    visibleProfileIds.insert(relationship.fromCharacterId)
                    visibleProfileIds.insert(relationship.toCharacterId)
                }
            }
        }
        
        return dataManager.allProfiles.filter { visibleProfileIds.contains($0.id) }
    }
    
    private func buildGraph(centerProfile: CharacterProfile, dataManager: DataManager) {
        nodes.removeAll()
        relationships.removeAll()
        
        let visibleProfiles = getVisibleProfiles(for: centerProfile, dataManager: dataManager)
        
        // Create nodes
        for (index, profile) in visibleProfiles.enumerated() {
            let isCenterNode = profile.id == centerProfile.id
            
            // Position nodes in a circle initially, with center at origin
            let angle = isCenterNode ? 0 : (CGFloat(index) / CGFloat(visibleProfiles.count - 1)) * 2 * .pi
            let radius: CGFloat = isCenterNode ? 0 : 150
            
            let node = GraphNode(
                profileId: profile.id,
                position: CGPoint(
                    x: cos(angle) * radius,
                    y: sin(angle) * radius
                ),
                velocity: .zero,
                radius: isCenterNode ? 30 : 25,
                isFixed: isCenterNode // Fix center node
            )
            
            nodes.append(node)
        }
        
        // Collect all relationships between visible profiles
        var relationshipSet = Set<CharacterRelationship>()
        
        for profile in visibleProfiles {
            let profileRelationships = dataManager.relationships(for: profile)
            for relationship in profileRelationships {
                // Only include if both nodes are visible
                if visibleProfiles.contains(where: { $0.id == relationship.fromCharacterId }) &&
                   visibleProfiles.contains(where: { $0.id == relationship.toCharacterId }) {
                    relationshipSet.insert(relationship)
                }
            }
        }
        
        relationships = Array(relationshipSet)
    }
    
    func updatePhysics(deltaTime: CGFloat) {
        guard iterationCount < maxIterations else { return }
        
        // Apply forces
        applyLinkForces()
        applyRepulsionForces()
        applyCenterForces()
        
        // Update positions using Verlet integration
        var totalVelocity: CGFloat = 0
        
        for i in 0..<nodes.count {
            guard !nodes[i].isFixed else { continue }
            
            // Apply damping
            nodes[i].velocity.x *= damping
            nodes[i].velocity.y *= damping
            
            // Update position
            nodes[i].position.x += nodes[i].velocity.x * deltaTime
            nodes[i].position.y += nodes[i].velocity.y * deltaTime
            
            // Track total velocity for convergence check
            totalVelocity += abs(nodes[i].velocity.x) + abs(nodes[i].velocity.y)
        }
        
        iterationCount += 1
        
        // Stop simulation if converged
        if totalVelocity < minVelocity * CGFloat(nodes.count) {
            iterationCount = maxIterations
        }
    }
    
    private func applyLinkForces() {
        for relationship in relationships {
            guard let fromIndex = nodes.firstIndex(where: { $0.profileId == relationship.fromCharacterId }),
                  let toIndex = nodes.firstIndex(where: { $0.profileId == relationship.toCharacterId }) else {
                continue
            }
            
            let dx = nodes[toIndex].position.x - nodes[fromIndex].position.x
            let dy = nodes[toIndex].position.y - nodes[fromIndex].position.y
            let distance = sqrt(dx * dx + dy * dy)
            
            guard distance > 0 else { continue }
            
            // Spring force
            let force = (distance - linkDistance) * linkStrength
            let fx = (dx / distance) * force
            let fy = (dy / distance) * force
            
            if !nodes[fromIndex].isFixed {
                nodes[fromIndex].velocity.x += fx
                nodes[fromIndex].velocity.y += fy
            }
            
            if !nodes[toIndex].isFixed {
                nodes[toIndex].velocity.x -= fx
                nodes[toIndex].velocity.y -= fy
            }
        }
    }
    
    private func applyRepulsionForces() {
        for i in 0..<nodes.count {
            for j in (i+1)..<nodes.count {
                let dx = nodes[j].position.x - nodes[i].position.x
                let dy = nodes[j].position.y - nodes[i].position.y
                let distanceSquared = dx * dx + dy * dy
                
                guard distanceSquared > 0 else { continue }
                
                let distance = sqrt(distanceSquared)
                let force = repulsionStrength / distanceSquared
                let fx = (dx / distance) * force
                let fy = (dy / distance) * force
                
                if !nodes[i].isFixed {
                    nodes[i].velocity.x -= fx
                    nodes[i].velocity.y -= fy
                }
                
                if !nodes[j].isFixed {
                    nodes[j].velocity.x += fx
                    nodes[j].velocity.y += fy
                }
            }
        }
    }
    
    private func applyCenterForces() {
        for i in 0..<nodes.count {
            guard !nodes[i].isFixed else { continue }
            
            let fx = -nodes[i].position.x * centerStrength
            let fy = -nodes[i].position.y * centerStrength
            
            nodes[i].velocity.x += fx
            nodes[i].velocity.y += fy
        }
    }
    
    func nodeAt(point: CGPoint) -> GraphNode? {
        // Check from back to front (reverse order) so top nodes are selected first
        for node in nodes.reversed() {
            let dx = point.x - node.position.x
            let dy = point.y - node.position.y
            let distanceSquared = dx * dx + dy * dy
            let touchRadius = max(node.radius, 22) // Minimum 44pt touch target
            
            if distanceSquared <= touchRadius * touchRadius {
                return node
            }
        }
        return nil
    }
    
    func resetPositions() {
        iterationCount = 0
        buildGraph(
            centerProfile: nodes.first { $0.profileId == centerProfileId }.map { node in
                CharacterProfile(
                    id: node.profileId,
                    requestId: "",
                    name: "",
                    age: nil,
                    occupation: "",
                    tagline: "",
                    physicalDescription: "",
                    personalityTraits: [],
                    backstory: ""
                )
            } ?? CharacterProfile(
                id: centerProfileId,
                requestId: "",
                name: "",
                age: nil,
                occupation: "",
                tagline: "",
                physicalDescription: "",
                personalityTraits: [],
                backstory: ""
            ),
            dataManager: DataManager(context: ModelContext(try! ModelContainer(
                for: CharacterProfile.self,
                configurations: ModelConfiguration()
            )))
        )
    }
    
    private func startSimulation() {
        simulationTimer?.invalidate()
        simulationTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            Task { @MainActor in
                self.updatePhysics(deltaTime: 1.0/60.0)
            }
        }
    }
    
    deinit {
        simulationTimer?.invalidate()
    }
}
