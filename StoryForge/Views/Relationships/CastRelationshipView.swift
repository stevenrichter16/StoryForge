//
//  CastRelationshipView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

// MARK: - Enhanced Cast Relationship Web View
struct CastRelationshipView: View {
    let cast: Cast
    @EnvironmentObject private var dataManager: DataManager
    @State private var selectedCharacterId: String?
    @State private var hoveredRelationshipId: String?
    @State private var showingLegend = true
    @State private var showingAddRelationship = false
    @State private var showingCharacterDetail = false
    @State private var detailProfile: CharacterProfile?
    @State private var viewMode: ViewMode = .web
    @State private var filterRelationshipType: String? = nil
    
    enum ViewMode: String, CaseIterable {
        case web = "Web"
        case matrix = "Matrix"
        case list = "List"
        
        var icon: String {
            switch self {
            case .web: return "network"
            case .matrix: return "square.grid.3x3"
            case .list: return "list.bullet"
            }
        }
    }
    
    private var castProfiles: [CharacterProfile] {
        dataManager.allProfiles.filter { profile in
            cast.characterIds.contains(profile.id)
        }
    }
    
    private var allRelationships: [CharacterRelationship] {
        var relationships: [CharacterRelationship] = []
        var seenPairs = Set<String>()
        
        for profile in castProfiles {
            let profileRelationships = dataManager.relationships(for: profile)
                .filter { relationship in
                    // Only include relationships within the cast
                    cast.characterIds.contains(relationship.fromCharacterId) &&
                    cast.characterIds.contains(relationship.toCharacterId)
                }
            
            for relationship in profileRelationships {
                // Create a unique key for the relationship pair
                let key = [relationship.fromCharacterId, relationship.toCharacterId].sorted().joined(separator: "-")
                if !seenPairs.contains(key) {
                    seenPairs.insert(key)
                    relationships.append(relationship)
                }
            }
        }
        
        // Apply filter if set
        if let filterType = filterRelationshipType {
            return relationships.filter { $0.relationshipType == filterType }
        }
        
        return relationships
    }
    
    private var relationshipTypes: [String] {
        Array(Set(allRelationships.map { $0.relationshipType })).sorted()
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            // Content based on view mode
            Group {
                switch viewMode {
                case .web:
                    if let centerProfile = getCenterProfile() {
                        OptimizedCastWebView(
                            cast: cast,
                            centerProfile: centerProfile,
                            castProfiles: castProfiles,
                            allRelationships: allRelationships
                        )
                    } else {
                        emptyCastView
                    }
                    
                case .matrix:
                    RelationshipMatrixView(
                        cast: cast,
                        profiles: castProfiles,
                        relationships: allRelationships
                    )
                    
                case .list:
                    CastRelationshipListView(
                        cast: cast,
                        profiles: castProfiles,
                        relationships: allRelationships
                    )
                }
            }
            
            // Overlay controls
            VStack {
                // Top controls
                HStack {
                    // View mode picker
                    Menu {
                        ForEach(ViewMode.allCases, id: \.self) { mode in
                            Button {
                                withAnimation {
                                    viewMode = mode
                                }
                            } label: {
                                Label(mode.rawValue, systemImage: mode.icon)
                            }
                        }
                    } label: {
                        Label(viewMode.rawValue, systemImage: viewMode.icon)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Filter menu
                    if !relationshipTypes.isEmpty {
                        Menu {
                            Button {
                                filterRelationshipType = nil
                            } label: {
                                Label("All Types", systemImage: filterRelationshipType == nil ? "checkmark" : "")
                            }
                            
                            Divider()
                            
                            ForEach(relationshipTypes, id: \.self) { type in
                                Button {
                                    filterRelationshipType = type
                                } label: {
                                    Label(
                                            type,
                                            systemImage: filterRelationshipType == type ? "checkmark" : ""
                                    )
                                }
                            }
                        } label: {
                            Label(
                                filterRelationshipType ?? "All Types",
                                systemImage: "line.3.horizontal.decrease.circle"
                            )
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        }
                    }
                    
                    // Legend toggle (for web view)
                    if viewMode == .web {
                        Button {
                            withAnimation {
                                showingLegend.toggle()
                            }
                        } label: {
                            Label(
                                showingLegend ? "Hide Legend" : "Show Legend",
                                systemImage: "list.bullet.rectangle"
                            )
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Bottom overlays
                VStack(spacing: 16) {
                    // Enhanced Legend (for web view)
                    if viewMode == .web && showingLegend && !relationshipTypes.isEmpty {
                        EnhancedRelationshipLegend(types: relationshipTypes)
                            .padding(.horizontal)
                    }
                    
                    // Cast info card
                    CastInfoCard(
                        cast: cast,
                        characterCount: castProfiles.count,
                        relationshipCount: allRelationships.count
                    )
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(cast.name)
                        .font(.headline)
                    Text("\(castProfiles.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddRelationship = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddRelationship) {
            AddCastRelationshipView(cast: cast)
        }
        .sheet(isPresented: $showingCharacterDetail) {
            if let profile = detailProfile,
               let request = dataManager.request(for: profile) {
                CharacterDetailView(profile: profile, request: request)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getCenterProfile() -> CharacterProfile? {
        // Try to get the selected character first
        if let selectedId = selectedCharacterId,
           let profile = castProfiles.first(where: { $0.id == selectedId }) {
            return profile
        }
        
        // Otherwise, find the character with the most relationships
        let characterRelationshipCounts = castProfiles.map { profile in
            let count = allRelationships.filter { relationship in
                relationship.fromCharacterId == profile.id ||
                relationship.toCharacterId == profile.id
            }.count
            return (profile: profile, count: count)
        }
        
        return characterRelationshipCounts.max(by: { $0.count < $1.count })?.profile ?? castProfiles.first
    }
    
    private var emptyCastView: some View {
        ContentUnavailableView(
            "No Characters",
            systemImage: "person.3.slash",
            description: Text("Add characters to this cast to see their relationships")
        )
    }
}

// MARK: - Optimized Cast Web View
struct OptimizedCastWebView: View {
    let cast: Cast
    let centerProfile: CharacterProfile
    let castProfiles: [CharacterProfile]
    let allRelationships: [CharacterRelationship]
    
    @StateObject private var webViewModel = CastWebViewModel()
    @State private var selectedCharacterId: String?
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var gestureOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            switch webViewModel.loadingState {
            case .idle:
                EmptyView()
                    .onAppear {
                        webViewModel.loadCastRelationships(
                            centerProfile: centerProfile,
                            castProfiles: castProfiles,
                            relationships: allRelationships
                        )
                    }
                
            case .loading:
                CastLoadingView()
                
            case .loaded:
                CastWebContent(
                    centerProfile: centerProfile,
                    nodePositions: webViewModel.nodePositions,
                    relationships: webViewModel.filteredRelationships,
                    profiles: webViewModel.visibleProfiles,
                    selectedCharacterId: $selectedCharacterId,
                    zoom: $zoom,
                    offset: $offset,
                    gestureOffset: $gestureOffset
                )
                
            case .error(let message):
                Text("Error: \(message)")
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Cast Web View Model
@MainActor
class CastWebViewModel: ObservableObject {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var loadingState: LoadingState = .idle
    @Published var nodePositions: [String: CGPoint] = [:]
    @Published var filteredRelationships: [CharacterRelationship] = []
    @Published var visibleProfiles: [CharacterProfile] = []
    
    func loadCastRelationships(
        centerProfile: CharacterProfile,
        castProfiles: [CharacterProfile],
        relationships: [CharacterRelationship]
    ) {
        loadingState = .loading
        
        Task.detached(priority: .userInitiated) { [weak self] in
            // Generate positions
            let positions = await self?.generateNodePositions(
                centerProfile: centerProfile,
                profiles: castProfiles
            ) ?? [:]
            
            await MainActor.run {
                self?.nodePositions = positions
                self?.filteredRelationships = relationships
                self?.visibleProfiles = castProfiles
                self?.loadingState = .loaded
            }
        }
    }
    
    private func generateNodePositions(
        centerProfile: CharacterProfile,
        profiles: [CharacterProfile]
    ) async -> [String: CGPoint] {
        var positions: [String: CGPoint] = [:]
        let screenSize = await UIScreen.main.bounds.size
        let center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        positions[centerProfile.id] = center
        
        let otherProfiles = profiles.filter { $0.id != centerProfile.id }
        let radius = min(screenSize.width, screenSize.height) * 0.25
        
        for (index, profile) in otherProfiles.enumerated() {
            let angle = (CGFloat(index) / CGFloat(otherProfiles.count)) * 2 * .pi
            positions[profile.id] = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
        }
        
        return positions
    }
}

// MARK: - Cast Loading View
struct CastLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("Loading Cast Relationships...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Cast Web Content
struct CastWebContent: View {
    let centerProfile: CharacterProfile
    let nodePositions: [String: CGPoint]
    let relationships: [CharacterRelationship]
    let profiles: [CharacterProfile]
    @Binding var selectedCharacterId: String?
    @Binding var zoom: CGFloat
    @Binding var offset: CGSize
    @Binding var gestureOffset: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Relationship lines
                ForEach(relationships, id: \.id) { relationship in
                    if let fromPos = nodePositions[relationship.fromCharacterId],
                       let toPos = nodePositions[relationship.toCharacterId] {
                        SimplifiedConnectionLine(
                            relationship: relationship,
                            from: transformPoint(fromPos),
                            to: transformPoint(toPos),
                            isHighlighted: isRelationshipHighlighted(relationship)
                        )
                    }
                }
                
                // Character nodes
                ForEach(profiles, id: \.id) { profile in
                    if let position = nodePositions[profile.id] {
                        SimplifiedCharacterNode(
                            profile: profile,
                            position: transformPoint(position),
                            isCenterCharacter: profile.id == centerProfile.id,
                            isSelected: selectedCharacterId == profile.id,
                            relationshipCount: relationshipCount(for: profile),
                            onTap: {
                                withAnimation {
                                    if selectedCharacterId == profile.id {
                                        selectedCharacterId = nil
                                    } else {
                                        selectedCharacterId = profile.id
                                    }
                                }
                            }
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            zoom = max(0.5, min(3.0, value))
                        },
                    DragGesture()
                        .onChanged { value in
                            gestureOffset = value.translation
                        }
                        .onEnded { value in
                            offset.width += value.translation.width
                            offset.height += value.translation.height
                            gestureOffset = .zero
                        }
                )
            )
        }
    }
    
    private func transformPoint(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x * zoom + offset.width + gestureOffset.width,
            y: point.y * zoom + offset.height + gestureOffset.height
        )
    }
    
    private func relationshipCount(for profile: CharacterProfile) -> Int {
        relationships.filter { relationship in
            relationship.fromCharacterId == profile.id ||
            relationship.toCharacterId == profile.id
        }.count
    }
    
    private func isRelationshipHighlighted(_ relationship: CharacterRelationship) -> Bool {
        guard let selectedId = selectedCharacterId else { return false }
        return relationship.fromCharacterId == selectedId ||
               relationship.toCharacterId == selectedId
    }
}
