//
//  StoreImpl.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation

class StoreImpl : Store {
    func loadInitData(onProgress: (Double) -> Void) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading time
        onProgress(0.1)
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading time
        onProgress(0.3)
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading time
        onProgress(0.5)
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading time
        onProgress(0.7)
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading time
        onProgress(0.9)
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading time
        onProgress(1)
    }
    
    func isirstStart() -> Bool {
        return UserDefaults.standard.bool(forKey: "is_first_start")
    }
    
    func setNoteFirstStart() {
        UserDefaults.standard.set(true, forKey: "is_first_start")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "is_logged_in")
    }
    
    func setLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "is_logged_in")
    }
}
