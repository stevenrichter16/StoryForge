//
//  ControlOverlay.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

import SwiftUI


// MARK: - Control Overlay
// MARK: - Control Overlay
// MARK: - Control Overlay
struct ControlOverlay: View {
    @Binding var zoom: CGFloat
    @Binding var offset: CGSize
    @Binding var gestureOffset: CGSize
    @Binding var showingLegend: Bool
    @Binding var showingCharacterInfo: Bool
    @Binding var selectedCharacterId: String?
    let selectedProfile: CharacterProfile?
    let relationshipTypes: Set<String>
    
    var body: some View {
        VStack {
            HStack {
                // Reset button
                Button {
                    withAnimation(.spring()) {
                        zoom = 1.0
                        offset = .zero
                        gestureOffset = .zero
                        selectedCharacterId = nil
                        showingCharacterInfo = false
                    }
                } label: {
                    Label("Reset", systemImage: "arrow.clockwise")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                }
                
                Spacer()
                
                // Zoom controls
                HStack(spacing: 12) {
                    Button {
                        withAnimation {
                            zoom = max(0.5, zoom - 0.2)
                        }
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                    
                    Text("\(Int(zoom * 100))%")
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(width: 50)
                    
                    Button {
                        withAnimation {
                            zoom = min(3.0, zoom + 0.2)
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
            
            // Legend and character info
            VStack(spacing: 16) {
                if showingLegend && !relationshipTypes.isEmpty {
                    EnhancedRelationshipLegend(types: Array(relationshipTypes))
                }
                
                if showingCharacterInfo, let profile = selectedProfile {
                    SelectedCharacterInfoCard(
                        profile: profile,
                        relationshipCount: 0, // Will be calculated in actual use
                        onClose: {
                            withAnimation {
                                selectedCharacterId = nil
                                showingCharacterInfo = false
                            }
                        }
                    )
                }
            }
            .padding()
        }
    }
}
