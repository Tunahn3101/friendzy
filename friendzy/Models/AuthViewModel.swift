//
//  AuthViewModel.swift
//  friendzy
//
//  Created by Tunahn on 22/6/26.
//

import SwiftUI
import Combine
import FirebaseAuth

/// Represents high-level authentication state for routing and UI.
enum AuthState: Equatable {
    case loading
    case unauthenticated
    case authenticated
    case error(String)
}

@MainActor
final class AuthViewModel: ObservableObject {
    /// Indicates an ongoing auth operation to disable repeated taps.
    @Published var isLoading = false

    /// Source of truth for authentication status.
    @Published var authState: AuthState = .unauthenticated

    /// Optional error message to present to the user.
    @Published var errorMessage: String? = nil

    /// The currently authenticated Firebase user.
    var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    /// Starts Google Sign-In flow. Updates `authState` upon completion.
    func loginGoogle() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await AuthServices.shared.signInGoogle()
            // If sign-in succeeds, mark as authenticated. Session/token handling is inside AuthServices.
            self.authState = .authenticated
        } catch is CancellationError {
            // User cancelled the sign-in flow; keep current state without surfacing an error.
        } catch {
            let message = error.localizedDescription
            self.errorMessage = message
            self.authState = .error(message)
        }
    }

    /// Attempts to restore a previous session (silent sign-in).
    /// Integrate with your session persistence (e.g., FirebaseAuth.currentUser) here.
    func restoreSession() async {
        self.authState = .loading
        if Auth.auth().currentUser != nil {
            self.authState = .authenticated
        } else {
            self.authState = .unauthenticated
        }
    }

    /// Signs the user out and resets state.
    func signOut() {
        do {
            try AuthServices.shared.signOut()
        } catch {
            // Log but don't block sign out UX.
        }
        self.authState = .unauthenticated
    }
}
