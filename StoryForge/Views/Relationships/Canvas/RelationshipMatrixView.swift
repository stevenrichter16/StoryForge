//
//  RelationshipMatrixView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

struct RelationshipMatrixView: View {
    let cast: Cast
    let profiles: [CharacterProfile]
    let relationships: [CharacterRelationship]
    @EnvironmentObject private var dataManager: DataManager
    @State private var selectedCell: (from: String, to: String)?
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 0) {
                // Header row
                HStack(spacing: 0) {
                    // Empty corner cell
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 100, height: 50)
                    
                    // Column headers
                    ForEach(profiles) { profile in
                        Text(profile.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .rotationEffect(.degrees(-45))
                            .frame(width: 60, height: 50)
                            .background(Color(.secondarySystemBackground))
                            .border(Color(.separator), width: 0.5)
                    }
                }
                
                // Matrix rows
                ForEach(profiles) { fromProfile in
                    HStack(spacing: 0) {
                        // Row header
                        Text(fromProfile.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .frame(width: 100, height: 60, alignment: .leading)
                            .padding(.horizontal, 8)
                            .background(Color(.secondarySystemBackground))
                            .border(Color(.separator), width: 0.5)
                        
                        // Matrix cells
                        ForEach(profiles) { toProfile in
                            MatrixCell(
                                fromProfile: fromProfile,
                                toProfile: toProfile,
                                relationship: findRelationship(from: fromProfile.id, to: toProfile.id),
                                isSelected: selectedCell?.from == fromProfile.id && selectedCell?.to == toProfile.id
                            ) {
                                selectedCell = (fromProfile.id, toProfile.id)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func findRelationship(from: String, to: String) -> CharacterRelationship? {
        relationships.first { relationship in
            (relationship.fromCharacterId == from && relationship.toCharacterId == to) ||
            (relationship.fromCharacterId == to && relationship.toCharacterId == from)
        }
    }
}
