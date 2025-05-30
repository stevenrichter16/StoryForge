//
//  GenreFilterRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct GenreFilterRow: View {
    let genre: Genre
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(Color(hex: genre.color))
                    .frame(width: 20, height: 20)
                
                Text(genre.name)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
