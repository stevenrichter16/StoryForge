//
//  FullRelationshipWebView.swift
//  StoryForge
//
//  Updated to use enhanced components
//

import SwiftUI

struct FullRelationshipWebView: View {
    let centerProfile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        EnhancedFullRelationshipWebView(centerProfile: centerProfile)
    }
}
