//
//  MainTabView.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var characterService: CharacterService
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch appState.selectedTab {
                case 0:
                    CreateCharacterView()
                case 1:
                    GalleryView()
//                case 2:
//                    FavoritesView()
                default:
                    CreateCharacterView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom tab bar
            CustomTabBar()
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @EnvironmentObject private var appState: AppState
    
    private let tabs: [(icon: String, selectedIcon: String, label: String, color: Color)] = [
        ("plus.circle", "plus.circle.fill", "Create", .blue),
        ("square.grid.2x2", "square.grid.2x2.fill", "Gallery", .purple),
        ("heart", "heart.fill", "Favorites", .red)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    icon: tabs[index].icon,
                    selectedIcon: tabs[index].selectedIcon,
                    label: tabs[index].label,
                    color: tabs[index].color,
                    isSelected: appState.selectedTab == index
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        appState.navigateToTab(index)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, y: -2)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

struct TabBarButton: View {
    let icon: String
    let selectedIcon: String
    let label: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? selectedIcon : icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isSelected ? color : Color(.systemGray))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(isSelected ? color : Color(.systemGray))
            }
            .frame(width: 80, height: 55)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}
