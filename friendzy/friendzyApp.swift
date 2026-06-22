//
//  friendzyApp.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI
import FirebaseCore

@main
struct friendzyApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
