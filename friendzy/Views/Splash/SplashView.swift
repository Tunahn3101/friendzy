//
//  SplashView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//
import SwiftUI

struct SplashView: View {
    @EnvironmentObject var storeEnv: StoreEnv
    @EnvironmentObject var auth: AuthViewModel
    @ObservedObject var splVM: SplashViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 0) {

            // Flexible space đẩy content xuống giữa
            Spacer()

            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundColor(.appPrimary) 
            //            Spacer(minLength: 16)
            Text("Friendzy")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            //            Spacer(minLength: 24)
            Text("Find your perfect match")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.bottom, 16)

            // Có thể dùng cái này giống như sizedbox flutter
            //            Color.clear.frame(height: 16)

            // Loading indicator (nếu cần)
            if splVM.percent > 0 {
                ProgressView(value: splVM.percent)
                    .progressViewStyle(.linear)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
            }
            // Flexible space đẩy content lên giữa
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)  //  Dùng màu base
        .onAppear {
            Task {
                splVM.store = storeEnv.store  // Inject store vào ViewModel
                await splVM.loadSplash()
                await auth.restoreSession(isFirstStart: splVM.isFirstStart)
            }
        }
    }
}
