//
//  LoginView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var storeEnv: StoreEnv

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingError = false
    @State private var navigateToEmailLogin = false
    @State private var navigateToSignUp = false

    var body: some View {
        VStack {
            Image("group")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)

            Text("Let's meeting new people around you")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
                .padding(.bottom, 32)

            VStack(spacing: 16) {

                ButtonItem(
                    icon: "envelope.fill",
                    text: "Login with Email",
                    color: Color.appPrimary,
                    textColor: .white,
                    isSystemImage: true,
                    isLoading: authViewModel.isLoading
                ) {
                    navigateToEmailLogin = true
                }
                .disabled(authViewModel.isLoading)

                ButtonItem(
                    icon: "icon_google",
                    text: "Login with Google",
                    color: Color.appPrimaryDark,
                    textColor: .black,
                    isSystemImage: false,
                    isLoading: authViewModel.isLoading
                ) {
                    print("Google login tapped")
                    handleGoogleLogin()
                }
                .disabled(authViewModel.isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            HStack {

                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(.black)

                Button(action: {
                    navigateToSignUp = true
                }) {
                    Text("Sign Up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pink)
                }

            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToEmailLogin) {
            EmailLoginView()
        }
        .navigationDestination(isPresented: $navigateToSignUp) {
            SignUpView()
        }
        .onChange(of: authViewModel.authState) { old, new in
            if case .error(_) = new {
                showingError = true
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authViewModel.errorMessage ?? "Unknown error")
        }
    }

    private func handleGoogleLogin() {
        Task { await authViewModel.loginGoogle() }
    }
}

struct ButtonItem: View {
    let icon: String
    let text: String
    let color: Color
    let textColor: Color
    let isSystemImage: Bool
    let isLoading: Bool
    let action: () -> Void

    init(
        icon: String,
        text: String,
        color: Color,
        textColor: Color,
        isSystemImage: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void,
    ) {
        self.icon = icon
        self.text = text
        self.color = color
        self.textColor = textColor
        self.isSystemImage = isSystemImage
        self.isLoading = isLoading
        self.action = action

    }

    var body: some View {
        Button(action: action) {
            ZStack {

                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)

                HStack {

                    if isSystemImage {
                        if isLoading {
                            ProgressView()
                                .frame(width: 36, height: 36)
                        } else {
                            Image(systemName: icon)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(color)
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                        }

                    } else {
                        if isLoading {
                            ProgressView()
                                .frame(width: 36, height: 36)
                        } else {
                            Image(icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)  // Size icon trong circle
                                .frame(width: 36, height: 36)  // Circle size
                                .background(Color.white)
                                .clipShape(Circle())
                        }

                    }

                    Spacer()
                }
                .padding(.leading, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(color)
            )
        }
        .disabled(isLoading)
        .buttonStyle(.plain)
    }
}

#Preview {
    LoginView()
        .environmentObject(StoreEnv(store: StoreImpl()))
        .environmentObject(AuthViewModel())
}
