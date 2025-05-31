//
//  OptimizedFullRelationshipWebView.swift
//  StoryForge
//
//  Performance-optimized relationship web visualization
//

import SwiftUI
import Combine

// MARK: - Optimized Full Relationship Web View
struct OptimizedFullRelationshipWebView: View {
    let centerProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    @StateObject private var webViewModel = RelationshipWebViewModel()
    @State private var selectedCharacterId: String?
    @State private var hoveredCharacterId: String?
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var showingLegend = true
    @State private var showingCharacterInfo = false
    @State private var gestureOffset: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background - lighter color for debugging
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                // Content based on loading state
                Group {
                    switch webViewModel.loadingState {
                    case .idle:
                        Color.clear
                            .onAppear {
                                print("🚀 Starting to load relationship web")
                                webViewModel.loadRelationships(
                                    for: centerProfile,
                                    dataManager: dataManager
                                )
                            }
                        
                    case .loading:
                        LoadingView()
                        
                    case .loaded:
                        WebVisualizationContent(
                            centerProfile: centerProfile,
                            nodePositions: webViewModel.nodePositions,
                            relationships: webViewModel.filteredRelationships,
                            profiles: webViewModel.connectedProfiles,
                            selectedCharacterId: $selectedCharacterId,
                            hoveredCharacterId: $hoveredCharacterId,
                            zoom: $zoom,
                            offset: $offset,
                            gestureOffset: $gestureOffset,
                            onNodeTap: handleNodeTap
                        )
                        .onAppear {
                            print("📈 Visualization content appeared")
                        }
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            webViewModel.loadRelationships(
                                for: centerProfile,
                                dataManager: dataManager
                            )
                        }
                    }
                }
                
                // Control overlay
                if webViewModel.loadingState == .loaded {
                    ControlOverlay(
                        zoom: $zoom,
                        offset: $offset,
                        gestureOffset: $gestureOffset,
                        showingLegend: $showingLegend,
                        showingCharacterInfo: $showingCharacterInfo,
                        selectedCharacterId: $selectedCharacterId,
                        selectedProfile: selectedProfile,
                        relationshipTypes: webViewModel.relationshipTypes
                    )
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
                    .disabled(webViewModel.loadingState != .loaded)
                }
            }
        }
        // Remove dark mode forcing for now to debug
        // .preferredColorScheme(.dark)
    }
    
    private var selectedProfile: CharacterProfile? {
        guard let selectedId = selectedCharacterId else { return nil }
        return webViewModel.connectedProfiles.first { $0.id == selectedId }
    }
    
    private func handleNodeTap(_ profileId: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if selectedCharacterId == profileId {
                selectedCharacterId = nil
                showingCharacterInfo = false
            } else {
                selectedCharacterId = profileId
                showingCharacterInfo = true
            }
        }
    }
}

// MARK: - View Model for Performance
@MainActor
class RelationshipWebViewModel: ObservableObject {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var loadingState: LoadingState = .idle
    @Published var nodePositions: [String: CGPoint] = [:]
    @Published var filteredRelationships: [CharacterRelationship] = []
    @Published var connectedProfiles: [CharacterProfile] = []
    @Published var relationshipTypes: Set<String> = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadRelationships(for centerProfile: CharacterProfile, dataManager: DataManager) {
        print("🔄 Loading relationships for: \(centerProfile.name)")
        loadingState = .loading
        
        // Perform heavy computation in background
        Task.detached(priority: .userInitiated) { [weak self] in
            do {
                // Calculate relationships and profiles
                let (relationships, profiles, types) = await self?.calculateRelationshipData(
                    for: centerProfile,
                    dataManager: dataManager
                ) ?? ([], [], [])
                
                print("📊 Found \(relationships.count) relationships and \(profiles.count) profiles")
                
                // Generate node positions
                let positions = await self?.generateNodePositions(
                    centerProfile: centerProfile,
                    profiles: profiles
                ) ?? [:]
                
                print("📍 Generated positions for \(positions.count) nodes")
                
                // Update UI on main thread
                await MainActor.run {
                    self?.filteredRelationships = relationships
                    self?.connectedProfiles = profiles
                    self?.relationshipTypes = types
                    self?.nodePositions = positions
                    self?.loadingState = .loaded
                    print("✅ Web view loaded successfully")
                }
            } catch {
                print("❌ Error loading web: \(error)")
                await MainActor.run {
                    self?.loadingState = .error(error.localizedDescription)
                }
            }
        }
    }
    
    private func calculateRelationshipData(
        for centerProfile: CharacterProfile,
        dataManager: DataManager
    ) async -> ([CharacterRelationship], [CharacterProfile], Set<String>) {
        print("🔍 Calculating relationships for \(centerProfile.name)")
        
        // Get direct relationships for the center profile
        let centerRelationships = dataManager.relationships(for: centerProfile)
        print("📊 Found \(centerRelationships.count) direct relationships")
        
        var connectedIds = Set<String>([centerProfile.id])
        
        // First degree connections
        for relationship in centerRelationships {
            connectedIds.insert(relationship.fromCharacterId)
            connectedIds.insert(relationship.toCharacterId)
        }
        
        print("👥 Connected IDs: \(connectedIds.count)")
        
        // Get all relationships that involve any connected character
        let relevantRelationships = dataManager.allRelationships.filter { relationship in
            let isRelevant = connectedIds.contains(relationship.fromCharacterId) ||
                            connectedIds.contains(relationship.toCharacterId)
            return isRelevant
        }
        
        print("🔗 Relevant relationships: \(relevantRelationships.count)")
        
        // Update connected IDs with all characters involved in relevant relationships
        for relationship in relevantRelationships {
            connectedIds.insert(relationship.fromCharacterId)
            connectedIds.insert(relationship.toCharacterId)
        }
        
        // Get connected profiles
        let profiles = dataManager.allProfiles.filter { connectedIds.contains($0.id) }
        print("👤 Connected profiles: \(profiles.count)")
        
        // Extract relationship types
        let types = Set(relevantRelationships.map { $0.relationshipType })
        print("🏷️ Relationship types: \(types)")
        
        return (relevantRelationships, profiles, types)
    }
    
    private func generateNodePositions(
        centerProfile: CharacterProfile,
        profiles: [CharacterProfile]
    ) async -> [String: CGPoint] {
        var positions: [String: CGPoint] = [:]
        
        // Get screen size on main thread
        let screenSize = await MainActor.run {
            UIScreen.main.bounds.size
        }
        
        let center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        print("📐 Screen size: \(screenSize), Center: \(center)")
        
        // Center node
        positions[centerProfile.id] = center
        
        // Other nodes in a circle
        let otherProfiles = profiles.filter { $0.id != centerProfile.id }
        print("🔵 Positioning \(otherProfiles.count) other profiles")
        
        if otherProfiles.isEmpty {
            print("⚠️ No other profiles to position")
            return positions
        }
        
        let radius = min(screenSize.width, screenSize.height) * 0.3
        
        for (index, profile) in otherProfiles.enumerated() {
            let angle = (CGFloat(index) / CGFloat(otherProfiles.count)) * 2 * .pi
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            positions[profile.id] = CGPoint(x: x, y: y)
            print("  - \(profile.name) at (\(Int(x)), \(Int(y)))")
        }
        
        return positions
    }
}












// MARK: - StarField Background
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



// MARK: - Selected Character Info Card
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
