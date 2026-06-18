//
//  MatchesView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 1/5/26.
//

import SwiftUI

struct MatchesView: View {
    let listSampleMatches = Array(sampleMatchesUsers.prefix(2))
    var body: some View {
        VStack(spacing: 0) {
            MatchesHeader()
            MatchesList(listMatches: listSampleMatches)
            YourMatchesView(listMatches: listSampleMatches)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
    }
}

struct YourMatchesView: View {
    let listUserDiscover: [UserModel] = sampleDiscoverUsers
    let listMatches: [MatchesModel]

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]
        let totalCount = listMatches.map(\.count).reduce(0, +)
        VStack(alignment: .leading, ) {
            HStack(spacing: 8) {
                Text("Your Matches")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "0xFF4B164C"))

                Text("\(totalCount)")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.appPrimary)
            }
            .padding(.leading, 16)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(listUserDiscover) { item in
                        GeometryReader { geo in
                            ZStack {
                                Image(item.avatarURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: geo.size.width,
                                        height: geo.size.width * 3 / 2
                                    )
                                    .clipped()
                                Text("\(item.percentMatch)% Match")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.appPrimary)
                                    .clipShape(
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 16,
                                                bottomTrailingRadius: 16,
                                                topTrailingRadius: 0
                                            )
                                        )
                                        .frame(
                                            width: geo.size.width,
                                            height: geo.size.width * 3 / 2,
                                            alignment: .top
                                        )

                                VStack(spacing: 6) {
                                    Text("\(item.distance) km away")
                                        .foregroundColor(.white)
                                        .font(
                                            .system(size: 16, weight: .semibold)
                                        )
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 5)
                                        .background(
                                            .ultraThinMaterial.opacity(0.28)
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    Color.white.opacity(0.35),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(
                                            color: Color.black.opacity(0.05),
                                            radius: 2,
                                            x: 0,
                                            y: 1
                                        )

                                    Text("\(item.name), \(item.age)")
                                        .foregroundColor(.white)
                                        .font(
                                            .system(size: 20, weight: .semibold)
                                        )

                                    Text("\(item.location)")
                                        .foregroundColor(.white.opacity(0.85))
                                        .font(.system(size: 16))
                                }
                                .padding(.bottom, 16)
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.width * 3 / 2,
                                    alignment: .bottom
                                )

                            }
                        }
                        .aspectRatio(2 / 3, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.appPrimary, lineWidth: 6)
                        )
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 16)
            }
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MatchesHeader: View {
    var body: some View {
        HStack {
            Text("Matches")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "0xFF4B164C"))
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "0xFF4B164C"), lineWidth: 1)
                )

        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)

    }
}

struct MatchesList: View {
    let listMatches: [MatchesModel]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(listMatches, id: \MatchesModel.id) { story in
                    VStack(spacing: 6) {
                        Image(story.avatarURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .blur(radius: 5)
                            .clipShape(Circle())
                            .overlay(content: {
                                Image(
                                    systemName: story.icon ?? "heart.fill"
                                )
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            })
                            .padding(4)
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color.appPrimary,
                                        lineWidth: 3
                                    )
                            )
                        HStack(spacing: 0) {
                            Text(story.title)
                                .font(.caption)
                                .foregroundColor(Color(hex: "0xFF4B164C"))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                            Text("\(story.count)")
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.appPrimary)

                        }
                    }
                    .onTapGesture {

                    }
                    .animation(.easeInOut, value: listMatches.count)
                }
            }
            .padding(16)
        }
        .frame(height: 110)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
}

#Preview {
    MatchesView()
}
