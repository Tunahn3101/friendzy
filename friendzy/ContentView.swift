//
//  ContentView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject var store = StoreEnv(store: StoreImpl())
    
    var body: some View {
        NavigationStack {
            SplashView()
        }
        .environmentObject(store)
    }
}
