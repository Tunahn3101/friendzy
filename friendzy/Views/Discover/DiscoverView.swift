//
//  DiscoverView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 1/5/26.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        VStack {
            DiscoverHeader()
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
    }
}

struct DiscoverHeader: View {
    var body: some View {
        HStack {
            Text("Friendzy")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "0xFF4B164C"))

            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "0xFF4B164C"), lineWidth: 1)
                )
            Spacer()
                .frame(width: 16)

            Image(systemName: "ellipsis")
                .font(.system(size: 22))
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "0xFF4B164C"), lineWidth: 1)
                )

        }
        .padding(.horizontal, 16)

    }
}

#Preview {
    DiscoverView()
}
