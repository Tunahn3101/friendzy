//
//  AuthServices.swift
//  friendzy
//
//  Created by Tunahn on 22/6/26.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class AuthServices {
    static let shared = AuthServices()

    private init() {}

    @MainActor
    func signInGoogle() async throws -> FirebaseAuth.User {

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "AuthServices", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing configuration"])
        }

        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        guard
            let scene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let rootViewController = scene.windows.first?.rootViewController
        else {
            throw NSError(domain: "AuthServices", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to find root view controller"])
        }

        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )

        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "AuthServices", code: 3, userInfo: [NSLocalizedDescriptionKey: "Missing idToken"])
        }

        let accessToken = result.user.accessToken.tokenString

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        
        print("Login successful: \(authResult.user.email ?? "No Email")")
        
        return authResult.user
    }

    func signUp(email: String, password: String, displayName: String) async throws -> FirebaseAuth.User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        return authResult.user
    }

    func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult.user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
}
