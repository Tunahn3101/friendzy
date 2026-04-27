//
//  ProfileView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Thông tin cá nhân")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.currentUser?.name ?? "Người dùng")
                                .font(.headline)
                            Text(viewModel.currentUser?.email ?? "email@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Cài đặt")) {
                    NavigationLink(destination: Text("Chỉnh sửa hồ sơ")) {
                        Label("Chỉnh sửa hồ sơ", systemImage: "pencil")
                    }
                    
                    NavigationLink(destination: Text("Thông báo")) {
                        Label("Thông báo", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: Text("Quyền riêng tư")) {
                        Label("Quyền riêng tư", systemImage: "lock")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Đăng xuất")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Hồ sơ")
        }
    }
}

#Preview {
    ProfileView()
}
