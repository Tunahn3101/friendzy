//
//  SplashViewModel.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Combine
import SwiftUI

@MainActor
class SplashViewModel: ObservableObject {
    // @Published phát thông báo khi một giá trị thay đổi, dùng trong ObservableObject
    @Published var percent: Double = 0.0
    @Published var loadStatus = LoadStatus.loading
    @Published var isFirstStart = false
    @Published var isLoggedIn = false
    var store: Store?

    func loadSplash() async {
        loadStatus = .loading
        
        // Load data - KHÔNG dùng nested Task nữa, await trực tiếp
        if let store = store {
            do {
                try await store.loadInitData(onProgress: { progress in
                    Task { @MainActor in
                        self.percent = progress
                    }
                })
            } catch {
                loadStatus = .failure(msg: "Load failed: \(error.localizedDescription)")
                return
            }
        } else {
            // Mock loading khi không có store
            for i in 1...10 {
                try? await Task.sleep(nanoseconds: 150_000_000)
                self.percent = Double(i) / 10.0  // @MainActor ở class level
            }
        }
        
        // Load xong → set success và load user state
        loadStatus = .success
        isFirstStart = store?.isirstStart() ?? true
        isLoggedIn = store?.isLoggedIn() ?? false
    }

    func setSecondStart() {
        store?.setNoteFirstStart()
    }

}
