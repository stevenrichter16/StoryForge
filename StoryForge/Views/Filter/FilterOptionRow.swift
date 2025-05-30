//
//  FilterOptionRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct FilterOptionRow: View {
    let option: GalleryView.FilterOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option.rawValue)
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
