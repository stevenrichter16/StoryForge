//
//  GalleryView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

// MARK: - GalleryView.swift
import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var appState: AppState
    @State private var selectedFilter: FilterOption = .all
    @State private var searchText = ""
    @State private var showingFilterSheet = false
    @State private var selectedCharacter: CharacterProfile?
    @State private var viewMode: ViewMode = .grid
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case byGenre = "By Genre"
        case byArchetype = "By Type"
        case recent = "Recent"
        case favorites = "Favorites"
    }
    
    enum ViewMode: String, CaseIterable {
        case grid = "Grid"
        case list = "List"
        case cast = "Cast"
    }
    
    private var filteredProfiles: [CharacterProfile] {
        var profiles = dataManager.allProfiles
        
        // Apply search
        if !searchText.isEmpty {
            profiles = profiles.filter { profile in
                profile.name.localizedCaseInsensitiveContains(searchText) ||
                profile.occupation.localizedCaseInsensitiveContains(searchText) ||
                profile.tagline.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .byGenre:
            if let genre = appState.activeFilter {
                profiles = dataManager.profiles(for: genre)
            }
        case .byArchetype:
            // Would need archetype filter in app state
            break
        case .recent:
            profiles = Array(profiles.prefix(10))
        case .favorites:
            profiles = profiles.filter { $0.isFavorite }
        }
        
        return profiles
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search and Filter Bar
                    SearchFilterBar(
                        searchText: $searchText,
                        selectedFilter: $selectedFilter,
                        viewMode: $viewMode,
                        showingFilterSheet: $showingFilterSheet
                    )
                    
                    // Content
                    if filteredProfiles.isEmpty {
                        EmptyGalleryView(
                            hasSearch: !searchText.isEmpty,
                            filter: selectedFilter
                        )
                    } else {
                        switch viewMode {
                        case .grid:
                            CharacterGridView(profiles: filteredProfiles)
                        case .list:
                            CharacterListView(profiles: filteredProfiles)
                        case .cast:
                            CastGroupView()
                        }
                    }
                }
            }
            .navigationTitle("Character Gallery")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFilterSheet) {
                FilterOptionsSheet(
                    selectedFilter: $selectedFilter,
                    selectedGenre: $appState.activeFilter
                )
            }
        }
    }
}
