//
//  SplashView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//
import SwiftUI

struct SplashView: View {
    @EnvironmentObject var storeEnv: StoreEnv
    @StateObject var splVM = SplashViewModel()
    @State var isShowNext = false

    var body: some View {

        VStack(alignment: .center, spacing: 0) {

            // Flexible space đẩy content xuống giữa
            Spacer()

            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "0xFFDD88CF"))
//            Spacer(minLength: 16)
            Text("Friendzy")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
//            Spacer(minLength: 24)
            Text("Find your perfect match")
                .font(.system(size: 14))
                .foregroundColor(.secondary)

            // Flexible space đẩy content lên giữa
            Spacer()

            // Loading indicator (nếu cần)
            if splVM.percent > 0 {
                ProgressView(value: splVM.percent)
                    .progressViewStyle(.linear)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex:  "0xFFFDF7FD"))
    }
}
