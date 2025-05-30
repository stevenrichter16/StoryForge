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

// Add these methods to DataManager.swift
extension DataManager {
    // MARK: - Cast Operations
    func save(cast: Cast) throws {
        modelContext.insert(cast)
        try modelContext.save()
        
        if !allCasts.contains(where: { $0.id == cast.id }) {
            allCasts.insert(cast, at: 0)
        }
        
        objectWillChange.send()
    }
    
    func delete(cast: Cast) throws {
        // Remove cast ID from all characters
        for characterId in cast.characterIds {
            if let request = allRequests.first(where: { $0.id == characterId }) {
                request.castId = nil
            }
        }
        
        modelContext.delete(cast)
        try modelContext.save()
        
        allCasts.removeAll { $0.id == cast.id }
        objectWillChange.send()
    }
    
    func update(cast: Cast) throws {
        cast.modifiedAt = Date()
        try modelContext.save()
        objectWillChange.send()
    }
    
    // MARK: - Relationship Operations
    func save(relationship: CharacterRelationship) throws {
        modelContext.insert(relationship)
        try modelContext.save()
        
        if !allRelationships.contains(where: { $0.id == relationship.id }) {
            allRelationships.append(relationship)
        }
        
        // Update the character's relationship IDs
        if let fromProfile = allProfiles.first(where: { $0.id == relationship.fromCharacterId }) {
            if !fromProfile.relationshipIds.contains(relationship.id) {
                fromProfile.relationshipIds.append(relationship.id)
            }
        }
        
        if let toProfile = allProfiles.first(where: { $0.id == relationship.toCharacterId }) {
            if !toProfile.relationshipIds.contains(relationship.id) {
                toProfile.relationshipIds.append(relationship.id)
            }
        }
        
        try modelContext.save()
        objectWillChange.send()
    }
    
    func delete(relationship: CharacterRelationship) throws {
        // Remove relationship ID from characters
        for profile in allProfiles {
            profile.relationshipIds.removeAll { $0 == relationship.id }
        }
        
        modelContext.delete(relationship)
        try modelContext.save()
        
        allRelationships.removeAll { $0.id == relationship.id }
        objectWillChange.send()
    }
    
    func relationships(for profile: CharacterProfile) -> [CharacterRelationship] {
        return allRelationships.filter { relationship in
            relationship.fromCharacterId == profile.id ||
            relationship.toCharacterId == profile.id
        }
    }
}

extension CharacterRelationship: Hashable {
    static func == (lhs: CharacterRelationship, rhs: CharacterRelationship) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
