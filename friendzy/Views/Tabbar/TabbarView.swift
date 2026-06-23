//
//  TabbarView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 1/5/26.
//

import SwiftUI

// MARK: - Default TabView-based Tab Bar
struct TabbarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            DiscoverView()
                .tag(1)
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
            
            MatchesView()
                .tag(2)
                .tabItem {
                    Label("Matches", systemImage: "heart")
                }
            
            MessageView()
                .tag(3)
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
            
            ProfileView()
                .tag(4)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.appPrimary)
        .navigationBarBackButtonHidden(true)
    }}

