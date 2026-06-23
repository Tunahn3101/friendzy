//
//  ProfileView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var animateItems = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header Profile Info Card with Gradient Ring
                VStack(spacing: 16) {
                    ZStack {
                        // Ring around avatar
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.appPrimary,
                                        Color.pink.opacity(0.8),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 108, height: 108)
                            .rotationEffect(.degrees(animateItems ? 360 : 0))

                        AsyncImage(url: auth.currentUser?.photoURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .frame(width: 96, height: 96)
                        .background(Color.white)
                        .clipShape(Circle())
                    }

                    VStack(spacing: 4) {
                        Text(auth.currentUser?.displayName ?? "Người dùng")
                            .font(
                                .system(
                                    size: 24,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .foregroundColor(.primary)

                        Text(auth.currentUser?.email ?? "email@example.com")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 40)
                .scaleEffect(animateItems ? 1.0 : 0.8)
                .opacity(animateItems ? 1.0 : 0.0)

                // Stats Row or Quick Info
                HStack(spacing: 40) {
                    ProfileStatItem(value: "12", label: "Matches")
                    ProfileStatItem(value: "8", label: "Friends")
                    ProfileStatItem(value: "98%", label: "Match Rate")
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    Color(UIColor.secondarySystemBackground).opacity(0.5)
                )
                .cornerRadius(16)
                .opacity(animateItems ? 1.0 : 0.0)
                .offset(y: animateItems ? 0 : 20)

                // Account Information Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Thông tin tài khoản")
                        .font(
                            .system(size: 16, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.primary)
                        .padding(.horizontal, 4)

                    VStack(spacing: 0) {
                        ProfileInfoRow(
                            label: "Mã người dùng (UID)",
                            value: auth.currentUser?.uid ?? "--"
                        )
                        Divider().padding(.leading, 16)
                        ProfileInfoRow(
                            label: "Số điện thoại",
                            value: auth.currentUser?.phoneNumber
                                ?? "Chưa cập nhật"
                        )
                        Divider().padding(.leading, 16)
                        ProfileInfoRow(
                            label: "Xác minh Email",
                            value: auth.currentUser?.isEmailVerified == true
                                ? "Đã xác minh ✅" : "Chưa xác minh ⚠️"
                        )

                        if let creationDate = auth.currentUser?.metadata
                            .creationDate
                        {
                            Divider().padding(.leading, 16)
                            ProfileInfoRow(
                                label: "Ngày tạo tài khoản",
                                value: creationDate.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                        }

                        if let lastSignInDate = auth.currentUser?.metadata
                            .lastSignInDate
                        {
                            Divider().padding(.leading, 16)
                            ProfileInfoRow(
                                label: "Đăng nhập gần nhất",
                                value: lastSignInDate.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                        }
                    }
                    .background(
                        Color(UIColor.secondarySystemBackground).opacity(0.4)
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .opacity(animateItems ? 1.0 : 0.0)
                .offset(y: animateItems ? 0 : 25)

                // Settings List
                VStack(spacing: 12) {

                    ProfileMenuRow(
                        icon: "bell.fill",
                        title: "Thông báo",
                        iconColor: .orange
                    )
                    ProfileMenuRow(
                        icon: "lock.fill",
                        title: "Quyền riêng tư",
                        iconColor: .green
                    )
                    ProfileMenuRow(
                        icon: "gearshape.fill",
                        title: "Cài đặt ứng dụng",
                        iconColor: .gray
                    )
                }
                .padding(.horizontal, 16)
                .opacity(animateItems ? 1.0 : 0.0)
                .offset(y: animateItems ? 0 : 30)

                Spacer()

                // Logout Button
                Button(action: {
                    withAnimation {
                        auth.signOut()
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .bold))
                        Text("Đăng xuất")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.red.opacity(0.85),
                                Color.pink.opacity(0.85),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(
                        color: Color.red.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
                .opacity(animateItems ? 1.0 : 0.0)
                .offset(y: animateItems ? 0 : 40)
            }
        }
        .background(Color.appBackground)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateItems = true
            }
        }
    }
}

struct ProfileStatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color.appPrimary)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.secondarySystemBackground).opacity(0.4))
        .cornerRadius(12)
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
