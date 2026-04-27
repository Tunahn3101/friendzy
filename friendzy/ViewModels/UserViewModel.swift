//
//  UserViewModel.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - UserViewModel
class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
        checkLoginStatus()
    }
    
    // MARK: - Methods
    func login(email: String, password: String) {
        isLoading = true
        
        // Giả lập login (sau này thay bằng API call thật)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(name: "Tuấn Anh", email: email)
            self.isLoggedIn = true
            self.isLoading = false
            self.saveLoginStatus()
        }
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
    
    func updateProfile(name: String, email: String) {
        guard var user = currentUser else { return }
        user.name = name
        user.email = email
        currentUser = user
    }
    
    // MARK: - Private Methods
    private func checkLoginStatus() {
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            // Load user data
            currentUser = User(name: "Tuấn Anh", email: "tuananh@example.com")
        }
    }
    
    private func saveLoginStatus() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
}
