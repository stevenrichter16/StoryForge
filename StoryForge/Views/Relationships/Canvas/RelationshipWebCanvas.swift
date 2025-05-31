//
//  RelationshipWebCanvas.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

//
//  RelationshipWebCanvas.swift
//  StoryForge
//
//  Enhanced high-performance relationship visualization
//

import SwiftUI

struct RelationshipWebCanvas: View {
    let centerProfile: CharacterProfile
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var webController = RelationshipWebController()
    @State private var selectedNodeId: String?
    @State private var hoveredNodeId: String?
    @State private var showingCharacterDetail = false
    @State private var detailProfile: CharacterProfile?
    @State private var transform = WebTransform()
    
    // Gesture states
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var pinchScale: CGFloat = 1.0
    
    private var allProfiles: [CharacterProfile] {
        webController.getVisibleProfiles(for: centerProfile, dataManager: dataManager)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // Canvas for high-performance rendering
                TimelineView(.animation(minimumInterval: 1.0/60.0)) { timeline in
                    Canvas { context, size in
                        // Apply transformations
                        context.translateBy(
                            x: size.width / 2 + transform.offset.width + dragOffset.width,
                            y: size.height / 2 + transform.offset.height + dragOffset.height
                        )
                        context.scaleBy(x: transform.scale * pinchScale, y: transform.scale * pinchScale)
                        
                        // Update physics
                        webController.updatePhysics(deltaTime: 1.0/60.0)
                        
                        // Draw relationships first (underneath nodes)
                        drawRelationships(context: context, size: size)
                        
                        // Draw nodes on top
                        drawNodes(context: context, size: size)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                // Overlay for interactions
                relationshipInteractionOverlay(in: geometry.size)
                
                // UI Controls
                webControlsOverlay()
            }
        }
        .onAppear {
            webController.initialize(
                centerProfile: centerProfile,
                dataManager: dataManager,
                viewSize: UIScreen.main.bounds.size
            )
        }
        .sheet(isPresented: $showingCharacterDetail) {
            if let profile = detailProfile,
               let request = dataManager.request(for: profile) {
                CharacterDetailView(profile: profile, request: request)
            }
        }
    }
    
    // MARK: - Canvas Drawing Methods
    
    private func drawRelationships(context: GraphicsContext, size: CGSize) {
        let relationships = webController.relationships
        
        for relationship in relationships {
            guard let fromNode = webController.nodes.first(where: { $0.profileId == relationship.fromCharacterId }),
                  let toNode = webController.nodes.first(where: { $0.profileId == relationship.toCharacterId }) else {
                continue
            }
            
            var path = Path()
            path.move(to: fromNode.position)
            
            // Create curved path for better visual separation
            let midPoint = CGPoint(
                x: (fromNode.position.x + toNode.position.x) / 2,
                y: (fromNode.position.y + toNode.position.y) / 2
            )
            let controlOffset = CGPoint(
                x: (toNode.position.y - fromNode.position.y) * 0.2,
                y: (fromNode.position.x - toNode.position.x) * 0.2
            )
            
            path.addQuadCurve(
                to: toNode.position,
                control: CGPoint(
                    x: midPoint.x + controlOffset.x,
                    y: midPoint.y + controlOffset.y
                )
            )
            
            // Style based on relationship type
            let color = colorForRelationshipType(relationship.relationshipType)
            let isHighlighted = selectedNodeId == relationship.fromCharacterId ||
                               selectedNodeId == relationship.toCharacterId ||
                               hoveredNodeId == relationship.fromCharacterId ||
                               hoveredNodeId == relationship.toCharacterId
            
            context.stroke(
                path,
                with: .color(color.opacity(isHighlighted ? 0.8 : 0.3)),
                style: StrokeStyle(
                    lineWidth: isHighlighted ? 3 : 1.5,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: relationship.characterRelationshipDescription.isEmpty ? [] : [5, 5]
                )
            )
            
            // Draw relationship label if highlighted
            if isHighlighted && !relationship.relationshipType.isEmpty {
                let labelPoint = CGPoint(x: midPoint.x, y: midPoint.y - 10)
                
                // Create text with background
                var text = Text(relationship.relationshipType)
                    .font(.caption)
                    .foregroundColor(.primary)
                
                // Draw background
                let textSize = CGSize(width: 80, height: 20)
                let backgroundRect = CGRect(
                    x: labelPoint.x - textSize.width/2,
                    y: labelPoint.y - textSize.height/2,
                    width: textSize.width,
                    height: textSize.height
                )
                
                context.fill(
                    RoundedRectangle(cornerRadius: 4).path(in: backgroundRect),
                    with: .color(.secondary.opacity(0.9))
                )
                
                context.draw(
                    text,
                    at: labelPoint,
                    anchor: .center
                )
            }
        }
    }
    
    private func drawNodes(context: GraphicsContext, size: CGSize) {
        for node in webController.nodes {
            guard let profile = dataManager.allProfiles.first(where: { $0.id == node.profileId }) else {
                continue
            }
            
            let isSelected = selectedNodeId == node.profileId
            let isHovered = hoveredNodeId == node.profileId
            let isCenterNode = node.profileId == centerProfile.id
            
            // Determine visual properties
            let radius = node.radius * (isSelected ? 1.2 : 1.0) * (isCenterNode ? 1.3 : 1.0)
            let nodeRect = CGRect(
                x: node.position.x - radius,
                y: node.position.y - radius,
                width: radius * 2,
                height: radius * 2
            )
            
            // Get genre color
            let genreColor = dataManager.request(for: profile)?.genre.color ?? "#808080"
            
            // Draw node shadow if selected
            if isSelected {
                let shadowPath = Circle().path(in: nodeRect.insetBy(dx: -4, dy: -4))
                context.fill(
                    shadowPath,
                    with: .color(Color(hex: genreColor).opacity(0.3))
                )
            }
            
            // Draw node background
            let nodePath = Circle().path(in: nodeRect)
            context.fill(
                nodePath,
                with: .color(Color(hex: genreColor).opacity(isCenterNode ? 0.4 : 0.2))
            )
            
            // Draw node border
            context.stroke(
                nodePath,
                with: .color(isSelected ? .yellow : Color(hex: genreColor)),
                style: StrokeStyle(lineWidth: isSelected ? 3 : (isCenterNode ? 2.5 : 2))
            )
            
            // Draw initials
            let initials = String(profile.name.prefix(2)).uppercased()
            var text = Text(initials)
                .font(.system(size: radius * 0.6, weight: .bold))
                .foregroundColor(Color(hex: genreColor))
            
            context.draw(
                text,
                at: node.position,
                anchor: .center
            )
            
            // Draw name label if selected or center node
            if isSelected || isCenterNode {
                var nameText = Text(profile.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                
                let labelPoint = CGPoint(x: node.position.x, y: node.position.y + radius + 15)
                
                // Draw background for label
                let labelSize = CGSize(width: 100, height: 20)
                let labelRect = CGRect(
                    x: labelPoint.x - labelSize.width/2,
                    y: labelPoint.y - labelSize.height/2,
                    width: labelSize.width,
                    height: labelSize.height
                )
                
                context.fill(
                    RoundedRectangle(cornerRadius: 4).path(in: labelRect),
                    with: .color(.secondary.opacity(0.9))
                )
                
                context.draw(
                    nameText,
                    at: labelPoint,
                    anchor: .center
                )
            }
            
            // Draw relationship count badge
            let relationshipCount = webController.relationships.filter { rel in
                rel.fromCharacterId == node.profileId || rel.toCharacterId == node.profileId
            }.count
            
            if relationshipCount > 0 {
                let badgeRadius: CGFloat = 10
                let badgeCenter = CGPoint(
                    x: node.position.x + radius * 0.7,
                    y: node.position.y - radius * 0.7
                )
                let badgeRect = CGRect(
                    x: badgeCenter.x - badgeRadius,
                    y: badgeCenter.y - badgeRadius,
                    width: badgeRadius * 2,
                    height: badgeRadius * 2
                )
                
                context.fill(
                    Circle().path(in: badgeRect),
                    with: .color(.blue)
                )
                
                var countText = Text("\(relationshipCount)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                context.draw(
                    countText,
                    at: badgeCenter,
                    anchor: .center
                )
            }
        }
    }
    
    // MARK: - Interaction Overlay
    
    private func relationshipInteractionOverlay(in size: CGSize) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                SimultaneousGesture(
                    // Tap gesture for selection
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width.magnitude < 10 && value.translation.height.magnitude < 10 {
                                // This is a tap, not a drag
                                handleTap(at: value.location, in: size)
                            }
                        },
                    
                    // Drag gesture for panning
                    DragGesture(minimumDistance: 10)
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            transform.offset.width += value.translation.width
                            transform.offset.height += value.translation.height
                        }
                )
            )
            .gesture(
                // Magnification gesture for zooming
                MagnificationGesture()
                    .updating($pinchScale) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        transform.scale *= value
                        transform.scale = max(0.5, min(3.0, transform.scale))
                    }
            )
    }
    
    // MARK: - Controls Overlay
    
    private func webControlsOverlay() -> some View {
        VStack {
            HStack {
                // Reset view button
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        transform = WebTransform()
                        webController.resetPositions()
                    }
                } label: {
                    Label("Reset View", systemImage: "arrow.counterclockwise")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // Zoom controls
                HStack(spacing: 12) {
                    Button {
                        withAnimation {
                            transform.scale = max(0.5, transform.scale - 0.2)
                        }
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                    
                    Text("\(Int(transform.scale * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 50)
                    
                    Button {
                        withAnimation {
                            transform.scale = min(3.0, transform.scale + 0.2)
                        }
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Selected character info
            if let selectedId = selectedNodeId,
               let selectedProfile = dataManager.allProfiles.first(where: { $0.id == selectedId }) {
                SelectedCharacterCard(
                    profile: selectedProfile,
                    relationships: webController.relationships.filter { rel in
                        rel.fromCharacterId == selectedId || rel.toCharacterId == selectedId
                    },
                    onClose: {
                        withAnimation {
                            selectedNodeId = nil
                        }
                    },
                    onViewProfile: {
                        detailProfile = selectedProfile
                        showingCharacterDetail = true
                    }
                )
                .padding()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleTap(at location: CGPoint, in viewSize: CGSize) {
        // Convert tap location to canvas coordinates
        let canvasLocation = CGPoint(
            x: (location.x - viewSize.width / 2 - transform.offset.width) / transform.scale,
            y: (location.y - viewSize.height / 2 - transform.offset.height) / transform.scale
        )
        
        // Find node at location
        if let tappedNode = webController.nodeAt(point: canvasLocation) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                if selectedNodeId == tappedNode.profileId {
                    // Double tap to view profile
                    if let profile = dataManager.allProfiles.first(where: { $0.id == tappedNode.profileId }) {
                        detailProfile = profile
                        showingCharacterDetail = true
                    }
                } else {
                    selectedNodeId = tappedNode.profileId
                }
            }
        } else {
            // Deselect if tapping empty space
            withAnimation {
                selectedNodeId = nil
            }
        }
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

// MARK: - Supporting Types

struct WebTransform {
    var offset: CGSize = .zero
    var scale: CGFloat = 1.0
}

struct SpatialTapGesture: Gesture {
    let coordinateSpace: CoordinateSpace
    
    var body: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
            .map { value in
                value.location
            }
    }
}

// MARK: - Selected Character Card

struct SelectedCharacterCard: View {
    let profile: CharacterProfile
    let relationships: [CharacterRelationship]
    let onClose: () -> Void
    let onViewProfile: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Character info
                HStack(spacing: 12) {
                    if let request = dataManager.request(for: profile) {
                        Circle()
                            .fill(Color(hex: request.genre.color).opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(profile.name.prefix(2).uppercased())
                                    .font(.headline)
                                    .foregroundColor(Color(hex: request.genre.color))
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.name)
                            .font(.headline)
                        
                        Text("\(relationships.count) relationships")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: onViewProfile) {
                        Image(systemName: "person.text.rectangle")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Relationship breakdown
            if !relationships.isEmpty {
                Divider()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(groupedRelationshipTypes, id: \.type) { group in
                            VStack(spacing: 4) {
                                Text("\(group.count)")
                                    .font(.headline)
                                    .foregroundColor(colorForRelationshipType(group.type))
                                
                                Text(group.type)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var groupedRelationshipTypes: [(type: String, count: Int)] {
        let groups = Dictionary(grouping: relationships) { $0.relationshipType }
        return groups.map { (type: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
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
