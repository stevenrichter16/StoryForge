//
//  EnhancedFullRelationshipWebView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//


//
//  EnhancedFullRelationshipWebView.swift
//  StoryForge
//
//  Created by Assistant on 5/31/25.
//

import SwiftUI

struct EnhancedFullRelationshipWebView: View {
    let centerProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    @State private var selectedCharacterId: String?
    @State private var hoveredCharacterId: String?
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var showingLegend = true
    @State private var showingCharacterInfo = false
    @State private var nodePositions: [String: CGPoint] = [:]
    @State private var isDragging = false
    
    private var allRelationships: [CharacterRelationship] {
        dataManager.allRelationships.filter { relationship in
            let centerConnections = dataManager.relationships(for: centerProfile)
            let connectedCharacterIds = Set(centerConnections.flatMap { [$0.fromCharacterId, $0.toCharacterId] })
            
            return connectedCharacterIds.contains(relationship.fromCharacterId) ||
                   connectedCharacterIds.contains(relationship.toCharacterId)
        }
    }
    
    private var allConnectedProfiles: [CharacterProfile] {
        let allCharacterIds = Set(allRelationships.flatMap { [$0.fromCharacterId, $0.toCharacterId] })
        return dataManager.allProfiles.filter { allCharacterIds.contains($0.id) }
    }
    
    private var relationshipTypes: Set<String> {
        Set(allRelationships.map { $0.relationshipType })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with subtle pattern
                Color.black
                    .overlay(
                        StarFieldBackground()
                            .opacity(0.3)
                    )
                    .ignoresSafeArea()
                
                // Main web visualization
                GeometryReader { geometry in
                    ZStack {
                        // Relationship connections
                        ForEach(allRelationships, id: \.id) { relationship in
                            if let fromPos = nodePositions[relationship.fromCharacterId],
                               let toPos = nodePositions[relationship.toCharacterId] {
                                EnhancedConnectionLine(
                                    relationship: relationship,
                                    from: fromPos,
                                    to: toPos,
                                    isHighlighted: isRelationshipHighlighted(relationship),
                                    zoom: zoom
                                )
                            }
                        }
                        
                        // Character nodes
                        ForEach(allConnectedProfiles, id: \.id) { profile in
                            if let position = nodePositions[profile.id] {
                                UnifiedCharacterNode(
                                    profile: profile,
                                    position: position,
                                    context: .fullWeb(isCenterCharacter: profile.id == centerProfile.id),
                                    isSelected: selectedCharacterId == profile.id,
                                    isHovered: hoveredCharacterId == profile.id,
                                    relationshipCount: relationshipCount(for: profile),
                                    zoom: zoom
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        selectedCharacterId = selectedCharacterId == profile.id ? nil : profile.id
                                        showingCharacterInfo = selectedCharacterId != nil
                                    }
                                }
                                .onHover { isHovered in
                                    hoveredCharacterId = isHovered ? profile.id : nil
                                }
                            }
                        }
                    }
                    .scaleEffect(zoom)
                    .offset(offset)
                    .onAppear {
                        calculateNodePositions(in: geometry.size)
                    }
                    .onChange(of: geometry.size) { newSize in
                        calculateNodePositions(in: newSize)
                    }
                }
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                zoom = max(0.5, min(3.0, value))
                            },
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                                isDragging = true
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                )
                
                // Control panel
                VStack {
                    HStack {
                        // Reset view button
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                zoom = 1.0
                                offset = .zero
                                selectedCharacterId = nil
                                showingCharacterInfo = false
                            }
                        } label: {
                            Label("Reset View", systemImage: "arrow.clockwise")
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                        }
                        
                        Spacer()
                        
                        // Zoom controls
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    zoom = max(0.5, zoom - 0.2)
                                }
                            } label: {
                                Image(systemName: "minus.magnifyingglass")
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                            }
                            
                            Text("\(Int(zoom * 100))%")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .cornerRadius(6)
                            
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    zoom = min(3.0, zoom + 0.2)
                                }
                            } label: {
                                Image(systemName: "plus.magnifyingglass")
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Legend
                    if showingLegend && !relationshipTypes.isEmpty {
                        EnhancedRelationshipLegend(types: Array(relationshipTypes))
                            .padding()
                    }
                    
                    // Selected character info
                    if showingCharacterInfo,
                       let selectedId = selectedCharacterId,
                       let selectedProfile = allConnectedProfiles.first(where: { $0.id == selectedId }) {
                        SelectedCharacterInfoCard(
                            profile: selectedProfile,
                            relationshipCount: relationshipCount(for: selectedProfile),
                            onClose: {
                                withAnimation {
                                    selectedCharacterId = nil
                                    showingCharacterInfo = false
                                }
                            }
                        )
                        .padding()
                    }
                }
            }
            .navigationTitle("Relationship Web")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showingLegend.toggle()
                        }
                    } label: {
                        Image(systemName: showingLegend ? "eye.slash" : "eye")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Helper Methods
    
    private func calculateNodePositions(in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let profiles = allConnectedProfiles
        
        nodePositions.removeAll()
        nodePositions[centerProfile.id] = center
        
        let otherProfiles = profiles.filter { $0.id != centerProfile.id }
        
        if otherProfiles.isEmpty { return }
        
        let radius = min(size.width, size.height) * 0.3
        let angleStep = (2 * Double.pi) / Double(otherProfiles.count)
        
        for (index, profile) in otherProfiles.enumerated() {
            let angle = Double(index) * angleStep
            let distance = radius + Double.random(in: -50...50)
            
            let position = CGPoint(
                x: center.x + CGFloat(cos(angle)) * distance,
                y: center.y + CGFloat(sin(angle)) * distance
            )
            
            nodePositions[profile.id] = position
        }
        
        applyForceDirectedLayout(in: size)
    }
    
    private func applyForceDirectedLayout(in size: CGSize) {
        let iterations = 50
        let nodeRadius: CGFloat = 40
        let repulsionStrength: CGFloat = 1000
        let attractionStrength: CGFloat = 0.1
        
        for _ in 0..<iterations {
            var forces: [String: CGPoint] = [:]
            
            for profile in allConnectedProfiles {
                forces[profile.id] = .zero
            }
            
            // Calculate repulsion forces
            for i in 0..<allConnectedProfiles.count {
                for j in (i+1)..<allConnectedProfiles.count {
                    let profile1 = allConnectedProfiles[i]
                    let profile2 = allConnectedProfiles[j]
                    
                    guard let pos1 = nodePositions[profile1.id],
                          let pos2 = nodePositions[profile2.id] else { continue }
                    
                    let dx = pos1.x - pos2.x
                    let dy = pos1.y - pos2.y
                    let distance = sqrt(dx * dx + dy * dy)
                    
                    if distance < nodeRadius * 3 && distance > 0 {
                        let force = repulsionStrength / (distance * distance)
                        let forceX = (dx / distance) * force
                        let forceY = (dy / distance) * force
                        
                        forces[profile1.id]!.x += forceX
                        forces[profile1.id]!.y += forceY
                        forces[profile2.id]!.x -= forceX
                        forces[profile2.id]!.y -= forceY
                    }
                }
            }
            
            // Calculate attraction forces for connected nodes
            for relationship in allRelationships {
                guard let pos1 = nodePositions[relationship.fromCharacterId],
                      let pos2 = nodePositions[relationship.toCharacterId] else { continue }
                
                let dx = pos2.x - pos1.x
                let dy = pos2.y - pos1.y
                let distance = sqrt(dx * dx + dy * dy)
                
                if distance > 0 {
                    let force = attractionStrength * distance
                    let forceX = (dx / distance) * force
                    let forceY = (dy / distance) * force
                    
                    forces[relationship.fromCharacterId]!.x += forceX
                    forces[relationship.fromCharacterId]!.y += forceY
                    forces[relationship.toCharacterId]!.x -= forceX
                    forces[relationship.toCharacterId]!.y -= forceY
                }
            }
            
            // Apply forces (but keep center character fixed)
            for profile in allConnectedProfiles where profile.id != centerProfile.id {
                guard let currentPos = nodePositions[profile.id],
                      let force = forces[profile.id] else { continue }
                
                let dampening: CGFloat = 0.1
                let newX = currentPos.x + force.x * dampening
                let newY = currentPos.y + force.y * dampening
                
                let margin: CGFloat = 60
                let boundedX = max(margin, min(size.width - margin, newX))
                let boundedY = max(margin, min(size.height - margin, newY))
                
                nodePositions[profile.id] = CGPoint(x: boundedX, y: boundedY)
            }
        }
    }
    
    private func relationshipCount(for profile: CharacterProfile) -> Int {
        allRelationships.filter { relationship in
            relationship.fromCharacterId == profile.id || relationship.toCharacterId == profile.id
        }.count
    }
    
    private func isRelationshipHighlighted(_ relationship: CharacterRelationship) -> Bool {
        guard let selectedId = selectedCharacterId else { return false }
        return relationship.fromCharacterId == selectedId || relationship.toCharacterId == selectedId
    }
}

// MARK: - Supporting Components

struct EnhancedRelationshipLegend: View {
    let types: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Relationship Types")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(types.sorted(), id: \.self) { type in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(colorForRelationshipType(type))
                            .frame(width: 12, height: 12)
                        
                        Text(type)
                            .font(.caption2)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func colorForRelationshipType(_ type: String) -> Color {
        switch type.lowercased() {
        case "family": return .blue
        case "friend", "best friend": return .green
        case "rival", "enemy": return .red
        case "mentor", "student": return .purple
        case "love interest", "partner": return .pink
        case "colleague": return .orange
        default: return .gray
        }
    }
}

struct SelectedCharacterInfoCard: View {
    let profile: CharacterProfile
    let relationshipCount: Int
    let onClose: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(hex: genre?.color ?? "#808080").opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Text(profile.name.prefix(2).uppercased())
                        .font(.headline)
                        .foregroundColor(Color(hex: genre?.color ?? "#808080"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(profile.occupation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let genreName = genre?.name {
                        Text(genreName)
                            .font(.caption)
                            .foregroundColor(Color(hex: genre?.color ?? "#808080"))
                    }
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
            
            HStack {
                Label("\(relationshipCount) relationships", systemImage: "person.2")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            if !profile.tagline.isEmpty {
                Text(profile.tagline)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct StarFieldBackground: View {
    @State private var stars: [Star] = []
    
    struct Star {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
    }
    
    var body: some View {
        Canvas { context, size in
            for star in stars {
                let rect = CGRect(x: star.x, y: star.y, width: star.size, height: star.size)
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(.white.opacity(star.opacity))
                )
            }
        }
        .onAppear {
            generateStars()
        }
    }
    
    private func generateStars() {
        stars = (0..<100).map { _ in
            Star(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.3...0.8)
            )
        }
    }
}
