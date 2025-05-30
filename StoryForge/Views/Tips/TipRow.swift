//
//  TipRow.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

import SwiftUI

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .fill(Color.orange)
                .frame(width: 6, height: 6)
                .offset(y: 6)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
