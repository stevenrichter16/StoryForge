//
//  CastGroupView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

// MARK: - Cast Group View
struct CastGroupView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingCreateCast = false
    @State private var selectedCast: Cast?
    
    var body: some View {
        ScrollView {
            if dataManager.allCasts.isEmpty {
                EmptyCastView(showingCreateCast: $showingCreateCast)
                    .padding(.top, 100)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(dataManager.allCasts) { cast in
                        CastCard(cast: cast, selectedCast: $selectedCast)
                    }
                }
                .padding()
            }
        }
        .navigationDestination(item: $selectedCast) { cast in
            CastDetailView(cast: cast)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingCreateCast = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateCast) {
            CreateCastView()
        }
    }
}
