//
//  SignUpView.swift
//  friendzy
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    @State private var showingError = false
    @State private var showingSuccess = false
    @State private var validationError: String? = nil
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Tạo tài khoản")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.appPrimary)
                    
                    Text("Kết nối và tìm kiếm nửa kia của bạn")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 24)
                
                // Inputs
                VStack(spacing: 16) {
                    // Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tên hiển thị")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        TextField("Tuấn Anh", text: $name)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                    
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
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Xác nhận mật khẩu")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if showConfirmPassword {
                                TextField("Xác nhận mật khẩu", text: $confirmPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                SecureField("••••••••", text: $confirmPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                
                // Register Button
                Button(action: {
                    guard password == confirmPassword else {
                        validationError = "Mật khẩu xác nhận không trùng khớp"
                        showingError = true
                        return
                    }
                    guard password.count >= 6 else {
                        validationError = "Mật khẩu phải dài ít nhất 6 ký tự"
                        showingError = true
                        return
                    }
                    
                    Task {
                        let success = await auth.signUp(
                            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            password: password,
                            displayName: name.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        if success {
                            showingSuccess = true
                        }
                    }
                }) {
                    HStack {
                        if auth.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Đăng ký")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Group {
                            if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                                Color.gray.opacity(0.5)
                            } else {
                                Color.appPrimary
                            }
                        }
                    )
                    .cornerRadius(16)
                }
                .disabled(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || auth.isLoading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: auth.authState) { old, new in
            if case .error(_) = new {
                validationError = nil
                showingError = true
            }
        }
        .alert("Thông báo", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationError ?? auth.errorMessage ?? "Đã xảy ra lỗi không xác định")
        }
        .alert("Thành công", isPresented: $showingSuccess) {
            Button("OK") {
                auth.setAuthenticated()
            }
        } message: {
            Text("Đăng ký tài khoản thành công! Chào mừng bạn đến với Friendzy.")
        }
    }
}

#Preview {
    NavigationView {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
