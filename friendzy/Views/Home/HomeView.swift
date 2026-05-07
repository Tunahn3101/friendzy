//
//  HomeView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    var body: some View {
        VStack {
         Image(systemName: "person")
//                .resizable()
//                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white,lineWidth: 3))
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        
            KFImage(URL(string: "https://picsum.photos/200"))

                       .resizable()

                       .scaledToFill()

                       .frame(width: 120, height: 120)

                       .clipped()
        
            
             
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
    }
}

