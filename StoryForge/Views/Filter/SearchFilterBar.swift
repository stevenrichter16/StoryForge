//
//  SearchFilterBar.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Search and Filter Bar
struct SearchFilterBar: View {
    @Binding var searchText: String
    @Binding var selectedFilter: GalleryView.FilterOption
    @Binding var viewMode: GalleryView.ViewMode
    @Binding var showingFilterSheet: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search characters...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            // Filter and View Options
            HStack {
                // Filter Button
                Button {
                    showingFilterSheet = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text(selectedFilter.rawValue)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // View Mode Picker
                Picker("View", selection: $viewMode) {
                    ForEach(GalleryView.ViewMode.allCases, id: \.self) { mode in
                        Image(systemName: viewModeIcon(for: mode))
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }
        }
        .padding()
    }
    
    private func viewModeIcon(for mode: GalleryView.ViewMode) -> String {
        switch mode {
        case .grid: return "square.grid.2x2"
        case .list: return "list.bullet"
        case .cast: return "person.3"
        }
    }
}
