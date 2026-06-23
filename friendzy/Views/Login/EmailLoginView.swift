//
//  EmailLoginView.swift
//  friendzy
//

import SwiftUI

struct EmailLoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showingError = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Chào mừng trở lại")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appPrimary)
                
                Text("Đăng nhập vào tài khoản của bạn")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
            // Input Fields
            VStack(spacing: 16) {
                // Email
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    TextField("example@email.com", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                }
                
                // Password
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mật khẩu")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    HStack {
                        if showPassword {
                            TextField("Mật khẩu", text: $password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            SecureField("••••••••", text: $password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            
            // Login Button
            Button(action: {
                Task {
                    await auth.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
                }
            }) {
                HStack {
                    if auth.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Đăng nhập")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Group {
                        if email.isEmpty || password.isEmpty {
                            Color.gray.opacity(0.5)
                        } else {
                            Color.appPrimary
                        }
                    }
                )
                .cornerRadius(16)
            }
            .disabled(email.isEmpty || password.isEmpty || auth.isLoading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: auth.authState) { old, new in
            if case .error(_) = new {
                showingError = true
            }
        }
        .alert("Lỗi", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(auth.errorMessage ?? "Đã xảy ra lỗi không xác định")
        }
    }
}

#Preview {
    NavigationView {
        EmailLoginView()
            .environmentObject(AuthViewModel())
    }
}
