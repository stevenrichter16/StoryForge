//
//  ExportOptionsView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct ExportOptionsView: View {
    let profile: CharacterProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ExportOption(
                        title: "Character Sheet (PDF)",
                        subtitle: "Professional format for printing",
                        icon: "doc.fill",
                        action: { exportAsPDF() }
                    )
                    
                    ExportOption(
                        title: "Markdown",
                        subtitle: "For writing apps and wikis",
                        icon: "doc.text",
                        action: { exportAsMarkdown() }
                    )
                    
                    ExportOption(
                        title: "JSON",
                        subtitle: "For developers and tools",
                        icon: "curlybraces",
                        action: { exportAsJSON() }
                    )
                }
                
                Section {
                    ExportOption(
                        title: "Share Link",
                        subtitle: "Share with other StoryForge users",
                        icon: "link",
                        action: { shareLink() }
                    )
                }
            }
            .navigationTitle("Export Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func exportAsPDF() {}
    private func exportAsMarkdown() {}
    private func exportAsJSON() {}
    private func shareLink() {}
}

struct ExportOption: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
