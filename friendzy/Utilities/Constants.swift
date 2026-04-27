//
//  Constants.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation
import SwiftUI

// MARK: - App Constants
enum AppConstants {
    // API URLs (cho sau này)
    static let baseURL = "https://api.friendzy.com"
    static let apiVersion = "v1"
    
    // UserDefaults Keys
    enum UserDefaultsKeys {
        static let isLoggedIn = "isLoggedIn"
        static let savedFriends = "SavedFriends"
        static let currentUser = "CurrentUser"
    }
    
    // Colors
    enum Colors {
        static let primaryColor = Color.blue
        static let secondaryColor = Color.gray
        static let accentColor = Color.green
    }
}
