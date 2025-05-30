//
//  FilterOptionsSheet.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Filter Options Sheet
struct FilterOptionsSheet: View {
    @Binding var selectedFilter: GalleryView.FilterOption
    @Binding var selectedGenre: Genre?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Filter Type
                Section("Filter Type") {
                    ForEach(GalleryView.FilterOption.allCases, id: \.self) { option in
                        FilterOptionRow(
                            option: option,
                            isSelected: selectedFilter == option,
                            action: {
                                selectedFilter = option
                                if option != .byGenre {
                                    selectedGenre = nil
                                }
                            }
                        )
                    }
                }
                
                // Genre Filter
                if selectedFilter == .byGenre {
                    Section("Select Genre") {
                        ForEach(Genre.all, id: \.id) { genre in
                            GenreFilterRow(
                                genre: genre,
                                isSelected: selectedGenre?.id == genre.id,
                                action: {
                                    selectedGenre = genre
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
