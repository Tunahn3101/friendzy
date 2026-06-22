//
//  ContentView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject var store = StoreEnv(store: StoreImpl())
    @StateObject var auth = AuthViewModel()
    @StateObject var splVM = SplashViewModel()

    var body: some View {
        Group {
            if splVM.loadStatus == .loading || auth.authState == .loading {
                SplashView(splVM: splVM)
            } else if splVM.isFirstStart {
                NavigationStack {
                    TutorialsView(splVM: splVM)
                }
            } else {
                switch auth.authState {
                case .authenticated:
                    TabbarView()
                case .unauthenticated, .error:
                    NavigationStack {
                        LoginView()
                    }
                }
            }
        }
        .environmentObject(store)
        .environmentObject(auth)
    }
}

