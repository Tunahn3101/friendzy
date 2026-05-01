//
//  LoginView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct LoginView: View {
    
    @State private var isNextScreen = false
    
    @EnvironmentObject var storeEnv: StoreEnv
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
                    icon: "phone.connection",
                    text: "Login with Phone",
                    color: .green,
                    textColor: .white,
                    isSystemImage: true
                ) {
                    print("Phone login tapped")
                    handlePhoneLogin()
                }

                ButtonItem(
                    icon: "icon_google",
                    text: "Login with Google",
                    color: Color.appPrimaryDark,
                    textColor: .black,
                    isSystemImage: false  //  Image từ Assets
                ) {
                    print("Google login tapped")
                    handleAppleLogin()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            HStack {

                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(.black)

                Button(action: {
                    print("Sign Up")
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
        .navigationDestination(isPresented: $isNextScreen) {
            TabbarView()  // ✅ Navigate to TabbarView instead of HomeView
        }
    }

    private func handleAppleLogin() {
       isNextScreen = true
        storeEnv.store.setLoggedIn(true)  // Giả lập đã login thành công
    }

    private func handlePhoneLogin() {
        isNextScreen = true
        storeEnv.store.setLoggedIn(true)  // Giả lập đã login thành công
    }
}

struct ButtonItem: View {
    let icon: String
    let text: String
    let color: Color
    let textColor: Color
    let isSystemImage: Bool  //  Thêm parameter để phân biệt SF Symbol vs Assets
    let action: () -> Void

    //  Khởi tạo với default isSystemImage = true (SF Symbol)
    init(
        icon: String,
        text: String,
        color: Color,
        textColor: Color,
        isSystemImage: Bool = true,  // Default là SF Symbol
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.text = text
        self.color = color
        self.textColor = textColor
        self.isSystemImage = isSystemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack {
             
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)

                // Icon ở bên trái
                HStack {

                    if isSystemImage {
                        // SF Symbol
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(color)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                    } else {
                        // Custom image từ Assets
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)  // Size icon trong circle
                            .frame(width: 36, height: 36)  // Circle size
                            .background(Color.white)
                            .clipShape(Circle())
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
        .buttonStyle(.plain)
    }
}
