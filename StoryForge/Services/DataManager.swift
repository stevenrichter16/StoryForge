import Foundation
import SwiftData
import SwiftUI

@MainActor
class DataManager: ObservableObject {
    @Published var allRequests: [CharacterRequest] = []
    @Published var allProfiles: [CharacterProfile] = []
    @Published var allCasts: [Cast] = []
    @Published var allRelationships: [CharacterRelationship] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let modelContext: ModelContext
    private var requestCache: [String: CharacterRequest] = [:]
    private var profileCache: [String: CharacterProfile] = [:]
    
    init(context: ModelContext) {
        self.modelContext = context
        loadData()
    }
    
    // MARK: - Data Loading
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load all data
            var requestDescriptor = FetchDescriptor<CharacterRequest>()
            requestDescriptor.sortBy = [SortDescriptor(\CharacterRequest.createdAt, order: .reverse)]
            allRequests = try modelContext.fetch(requestDescriptor)
            
            var profileDescriptor = FetchDescriptor<CharacterProfile>()
            profileDescriptor.sortBy = [SortDescriptor(\CharacterProfile.dateCreated, order: .reverse)]
            allProfiles = try modelContext.fetch(profileDescriptor)
            
            var castDescriptor = FetchDescriptor<Cast>()
            castDescriptor.sortBy = [SortDescriptor(\Cast.createdAt, order: .reverse)]
            allCasts = try modelContext.fetch(castDescriptor)
            
            rebuildCaches()
            print("📊 DataManager: Loaded \(allRequests.count) requests, \(allProfiles.count) profiles")
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            print("❌ DataManager: Failed to load data - \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Cache Management
    private func rebuildCaches() {
        requestCache.removeAll()
        profileCache.removeAll()
        
        for request in allRequests {
            requestCache[request.id] = request
        }
        
        for profile in allProfiles {
            profileCache[profile.id] = profile
        }
    }
    
    // MARK: - Save Operations
    func save(request: CharacterRequest) throws {
        modelContext.insert(request)
        try modelContext.save()
        
        if !allRequests.contains(where: { $0.id == request.id }) {
            allRequests.insert(request, at: 0)
        }
        
        requestCache[request.id] = request
        objectWillChange.send()
    }
    
    func save(profile: CharacterProfile) throws {
        modelContext.insert(profile)
        try modelContext.save()
        
        if !allProfiles.contains(where: { $0.id == profile.id }) {
            allProfiles.insert(profile, at: 0)
        }
        
        if let request = allRequests.first(where: { $0.id == profile.requestId }) {
            request.profileId = profile.id
            try modelContext.save()
        }
        
        profileCache[profile.id] = profile
        objectWillChange.send()
    }
    
    // MARK: - Query Operations
    func profile(for request: CharacterRequest) -> CharacterProfile? {
        guard let profileId = request.profileId else { return nil }
        return profileCache[profileId]
    }
    
    func request(for profile: CharacterProfile) -> CharacterRequest? {
        return requestCache[profile.requestId]
    }
    
    func profiles(for genre: Genre) -> [CharacterProfile] {
        return allProfiles.filter { profile in
            guard let request = request(for: profile) else { return false }
            return request.genre.id == genre.id
        }
    }
    
    func profiles(for archetype: CharacterArchetype) -> [CharacterProfile] {
        return allProfiles.filter { profile in
            guard let request = request(for: profile) else { return false }
            return request.archetype.id == archetype.id
        }
    }
    
    func favoriteProfiles() -> [CharacterProfile] {
        return allProfiles.filter { $0.isFavorite }
    }
    
    // MARK: - Delete Operations
    func delete(request: CharacterRequest) throws {
        if let profileId = request.profileId,
           let profile = profileCache[profileId] {
            try delete(profile: profile)
        }
        
        modelContext.delete(request)
        try modelContext.save()
        
        allRequests.removeAll { $0.id == request.id }
        requestCache.removeValue(forKey: request.id)
        objectWillChange.send()
    }
    
    func delete(profile: CharacterProfile) throws {
        modelContext.delete(profile)
        try modelContext.save()
        
        allProfiles.removeAll { $0.id == profile.id }
        profileCache.removeValue(forKey: profile.id)
        
        if let request = allRequests.first(where: { $0.profileId == profile.id }) {
            request.profileId = nil
            try modelContext.save()
        }
        
        objectWillChange.send()
    }
    
    func toggleFavorite(for profile: CharacterProfile) throws {
        profile.isFavorite.toggle()
        try modelContext.save()
        objectWillChange.send()
    }
}
