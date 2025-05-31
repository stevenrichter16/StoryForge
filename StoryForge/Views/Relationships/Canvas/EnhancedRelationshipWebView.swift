//
//  EnhancedRelationshipWebView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

//
//  EnhancedRelationshipWebView.swift
//  StoryForge
//
//  Main relationship web view with Canvas implementation
//

import SwiftUI

struct EnhancedRelationshipWebView: View {
    let centerProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddRelationship = false
    @State private var showingRelationshipList = false
    
    var body: some View {
        NavigationStack {
            RelationshipWebCanvas(centerProfile: centerProfile)
                .navigationTitle("Relationship Web")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Done") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                showingAddRelationship = true
                            } label: {
                                Label("Add Relationship", systemImage: "plus")
                            }
                            
                            Button {
                                showingRelationshipList = true
                            } label: {
                                Label("List View", systemImage: "list.bullet")
                            }
                            
                            Divider()
                            
                            Button {
                                // Export functionality
                            } label: {
                                Label("Export Web", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .sheet(isPresented: $showingAddRelationship) {
                    AddRelationshipView(fromProfile: centerProfile)
                }
                .sheet(isPresented: $showingRelationshipList) {
                    RelationshipListView(profile: centerProfile)
                }
        }
    }
}
