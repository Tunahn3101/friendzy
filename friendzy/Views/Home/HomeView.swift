//
//  HomeView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Kingfisher
import SwiftUI
import AVKit
import Combine

struct Story: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatarURL: String
    let videoURL: String?
}

struct HomeView: View {
    let listStories: [Story] = [
        Story(name: "tunahn.3101", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_1.png", videoURL: "https://assets.mixkit.co/videos/preview/mixkit-woman-taking-a-selfie-at-the-beach-4058-large.mp4"),
        Story(name: "Lina", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png", videoURL: nil),
        Story(name: "Mark", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png", videoURL: "https://assets.mixkit.co/videos/preview/mixkit-young-woman-vlogging-about-her-outfit-4094-large.mp4"),
        Story(name: "Anna", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_10.png", videoURL: nil),
        Story(name: "Tom", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_1.png", videoURL: "https://assets.mixkit.co/videos/preview/mixkit-girl-dancing-and-listening-to-music-with-headphones-1228-large.mp4"),
        Story(name: "Sara", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_3.png", videoURL: nil),
        Story(name: "Eve", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/bluey_1.png", videoURL: nil),
        Story(name: "Mia", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_1.png", videoURL: nil),
        Story(name: "Kai", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_5.png", videoURL: nil),
        Story(name: "Neo", avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/notion_1.png", videoURL: nil),
    ]

    @State private var selectedVideoURL: URL? = nil
    @State private var seenStories: Set<UUID> = []

    private let seenKey = "seenStories"

    private func loadSeenStories() {
        if let arr = UserDefaults.standard.stringArray(forKey: seenKey) {
            let ids = arr.compactMap { UUID(uuidString: $0) }
            seenStories = Set(ids)
        }
    }

    private func saveSeenStories() {
        let arr = seenStories.map { $0.uuidString }
        UserDefaults.standard.set(arr, forKey: seenKey)
    }

    var body: some View {
        VStack(spacing: 0) {
            HomeHeader()
            HomeStory(listStories: listStories, seenStories: seenStories) { story in
                // mark as seen and persist
                seenStories.insert(story.id)
                saveSeenStories()
                // open selected video if available
                if let v = story.videoURL, let url = URL(string: v) {
                    selectedVideoURL = url
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.appBackground)
        .onAppear { loadSeenStories() }
        // present full screen player when a video is selected
        .fullScreenCover(isPresented: Binding(get: { selectedVideoURL != nil }, set: { if !$0 { selectedVideoURL = nil } })) {
            if let url = selectedVideoURL {
                StoryVideoPlayer(url: url) {
                    // on finish, dismiss
                    selectedVideoURL = nil
                }
            }
        }
    }
}

struct HomeStory: View {
    let listStories: [Story]
    // which stories have been seen (their ids)
    let seenStories: Set<UUID>
    // callback when tapping a story (video or not)
    var onTapStory: (Story) -> Void = { _ in }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                VStack {
                    ZStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 28))
                            .frame(width: 64, height: 64)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color(hex: "0xFF4B164C")))
                        Circle()
                            .fill(Color(hex: "0xFFDD88CF"))
                            .frame(width: 20, height: 20)
                            .overlay {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(2)
                            .background(
                                Circle().fill(Color(.white))
                            )
                            .offset(x: 20, y: 20)
                    }
                    Spacer()
                    Text("My Story")
                        .font(.caption)
                        .foregroundColor(Color(hex: "0xFF4B164C"))
                        .lineLimit(1)
                        .frame(width: 64)
                    
                }

                ForEach(listStories) { story in
                    // only show ring for stories that have a valid video
                    let hasVideo = (story.videoURL != nil) && (URL(string: story.videoURL!) != nil)
                    let isSeen = seenStories.contains(story.id)
                    VStack(spacing: 6) {
                        KFImage(URL(string: story.avatarURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .padding(4)
                            .overlay(
                                Group {
                                    if hasVideo {
                                        if isSeen {
                                            Circle()
                                                .stroke(Color.gray.opacity(0.4), lineWidth: 3)
                                        } else {
                                            StoryGradientRing()
                                                .frame(width: 72, height: 72)
                                        }
                                    }
                                }
                            )

                        Text(story.name)
                            .font(.caption)
                            .foregroundColor(Color(hex: "0xFF4B164C"))
                            .lineLimit(1)
                            .frame(width: 64)
                    }
                    .onTapGesture {
                        // mark seen and call callback
                        onTapStory(story)
                    }
                    .animation(.easeInOut, value: isSeen)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
        .frame(height: 110)
    }

}

struct HomeHeader: View {
    var body: some View {
        HStack {
            Text("Friendzy")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "0xFF4B164C"))

            Spacer()
            Image(systemName: "bell.badge")
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

// MARK: - Video player helper that auto-dismisses when playback finishes
final class PlayerObserver: ObservableObject {
    let player: AVPlayer
    private var token: Any?
    private let onFinish: () -> Void

    init(url: URL, onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        let item = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: item)
        // observe end of item
        token = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak self] _ in
            self?.onFinish()
        }
    }

    deinit {
        if let t = token {
            NotificationCenter.default.removeObserver(t)
        }
    }

    func play() {
        player.play()
    }

    func stop() {
        player.pause()
        player.seek(to: .zero)
    }
}

struct StoryVideoPlayer: View {
    let url: URL
    let onFinish: () -> Void
    @StateObject private var observer: PlayerObserver

    init(url: URL, onFinish: @escaping () -> Void) {
        self.url = url
        self.onFinish = onFinish
        _observer = StateObject(wrappedValue: PlayerObserver(url: url, onFinish: onFinish))
    }

    var body: some View {
        VideoPlayer(player: observer.player)
            .edgesIgnoringSafeArea(.all)
            .onAppear { observer.play() }
            .onDisappear { observer.stop() }
    }
}

// Gradient ring like Instagram
struct StoryGradientRing: View {
    @State private var rotate = false

    var body: some View {
        // AngularGradient rotated over time to create subtle animation
        Circle()
            .strokeBorder(AngularGradient(gradient: Gradient(colors: [Color(hex: "0xFFDD88CF"), Color(hex: "0xFF4B164C"), Color(hex: "0xFFFF69B4"), Color(hex: "0xFFDD88CF")]), center: .center), lineWidth: 3)
            .rotationEffect(.degrees(rotate ? 360 : 0))
            .animation(.linear(duration: 6).repeatForever(autoreverses: false), value: rotate)
            .onAppear { rotate = true }
    }
}

#Preview {
    HomeView()
}
