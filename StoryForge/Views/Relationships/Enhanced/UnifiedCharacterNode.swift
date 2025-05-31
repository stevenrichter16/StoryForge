//
//  UnifiedCharacterNode.swift
//  StoryForge
//
//  Fixed to improve tap detection
//

import SwiftUI

// MARK: - Unified Character Node Component
struct UnifiedCharacterNode: View {
    let profile: CharacterProfile
    let position: CGPoint
    let context: NodeContext
    let isSelected: Bool
    let isHovered: Bool
    let relationshipCount: Int
    let zoom: CGFloat
    let onTap: (() -> Void)?
    
    @EnvironmentObject private var dataManager: DataManager
    
    enum NodeContext {
        case preview(isCenterCharacter: Bool)
        case fullWeb(isCenterCharacter: Bool)
        case grid
        
        var baseSize: CGFloat {
            switch self {
            case .preview(let isCenter):
                return isCenter ? 70 : 50
            case .fullWeb(let isCenter):
                return isCenter ? 80 : 60
            case .grid:
                return 60
            }
        }
        
        var showsGlow: Bool {
            switch self {
            case .preview(let isCenter), .fullWeb(let isCenter):
                return isCenter
            case .grid:
                return false
            }
        }
        
        var showsRelationshipBadge: Bool {
            switch self {
            case .preview(let isCenter), .fullWeb(let isCenter):
                return !isCenter
            case .grid:
                return true
            }
        }
        
        var showsNameLabel: Bool {
            switch self {
            case .preview, .fullWeb:
                return true
            case .grid:
                return false
            }
        }
    }
    
    private var genre: Genre? {
        guard let request = dataManager.request(for: profile) else { return nil }
        return request.genre
    }
    
    private var nodeColor: Color {
        Color(hex: genre?.color ?? "#808080")
    }
    
    private var nodeSize: CGFloat {
        let baseSize = context.baseSize
        let scaleFactor = isSelected ? 1.2 : (isHovered ? 1.1 : 1.0)
        let zoomAdjustment = zoom > 0 ? zoom : 1.0
        return baseSize * scaleFactor / zoomAdjustment
    }
    
    private var tapTargetSize: CGFloat {
        // Ensure a minimum tap target size of 44 points
        return max(nodeSize, 44 / zoom)
    }
    
    var body: some View {
        ZStack {
            // Invisible tap target for better hit detection
            Circle()
                .fill(Color.clear)
                .frame(width: tapTargetSize, height: tapTargetSize)
                .contentShape(Circle())
                .onTapGesture {
                    onTap?()
                }
            
            // Glow effect for center characters
            if context.showsGlow {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                nodeColor.opacity(0.4),
                                nodeColor.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: nodeSize * 0.3,
                            endRadius: nodeSize * 1.5
                        )
                    )
                    .frame(width: nodeSize * 2, height: nodeSize * 2)
                    .blur(radius: 3)
                    .allowsHitTesting(false)
            }
            
            // Selection ring
            if isSelected {
                Circle()
                    .stroke(Color.yellow, lineWidth: 4)
                    .frame(width: nodeSize + 16, height: nodeSize + 16)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isSelected)
                    .allowsHitTesting(false)
            }
            
            // Main node
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            nodeColor,
                            nodeColor.opacity(0.7)
                        ],
                        center: .topLeading,
                        startRadius: nodeSize * 0.1,
                        endRadius: nodeSize * 0.8
                    )
                )
                .frame(width: nodeSize, height: nodeSize)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                .allowsHitTesting(false)
            
            // Character initials
            Text(profile.name.prefix(2).uppercased())
                .font(.system(size: nodeSize * 0.35, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2)
                .allowsHitTesting(false)
            
            // Relationship count badge
            if context.showsRelationshipBadge && relationshipCount > 0 {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    Text("\(relationshipCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: nodeSize * 0.4, y: -nodeSize * 0.4)
                .allowsHitTesting(false)
            }
            
            // Character name label (conditional)
            if context.showsNameLabel && (isHovered || isSelected) {
                VStack {
                    Spacer()
                    
                    Text(profile.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.7))
                                .overlay(
                                    Capsule()
                                        .stroke(nodeColor, lineWidth: 1)
                                )
                        )
                        .offset(y: nodeSize * 0.7)
                        .allowsHitTesting(false)
                }
                .frame(width: nodeSize, height: nodeSize)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .position(position)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isHovered)
    }
}
