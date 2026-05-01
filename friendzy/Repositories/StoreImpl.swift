//
//  StoreImpl.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation

class StoreImpl: Store {
    func loadInitData(onProgress: (Double) -> Void) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)  // Simulate loading time
        onProgress(0.1)
        try await Task.sleep(nanoseconds: 500_000_000)  // Simulate loading time
        onProgress(0.3)
        try await Task.sleep(nanoseconds: 500_000_000)  // Simulate loading time
        onProgress(0.5)
        try await Task.sleep(nanoseconds: 500_000_000)  // Simulate loading time
        onProgress(0.7)
        try await Task.sleep(nanoseconds: 500_000_000)  // Simulate loading time
        onProgress(0.9)
        try await Task.sleep(nanoseconds: 500_000_000)  // Simulate loading time
        onProgress(1)
    }

    // - Nếu key chưa tồn tại (nil) → lần đầu chạy → return TRUE
    // - Nếu key = true → đã xem tutorials rồi → return FALSE
    func isirstStart() -> Bool {
        // Nếu key chưa set bao giờ → object(forKey:) return nil → đây là lần đầu
        if UserDefaults.standard.object(forKey: "has_seen_tutorials") == nil {
            return true  // Chưa xem tutorials
        }
        // Nếu đã set rồi, lấy giá trị
        return !UserDefaults.standard.bool(forKey: "has_seen_tutorials")
    }

    // Set đã xem tutorials rồi
    func setNoteFirstStart() {
        UserDefaults.standard.set(true, forKey: "has_seen_tutorials")
    }

    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "is_logged_in")
    }

    func setLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "is_logged_in")
    }
}
