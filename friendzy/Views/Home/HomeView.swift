//
//  HomeView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import AVKit
import Combine
import Kingfisher
import SwiftUI

struct Story: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let avatarURL: String
    let localVideoName: String?
}

struct HomeView: View {
    let listStories: [Story] = [
        Story(
            name: "tunahn.3101",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_1.png",
            localVideoName: "short_1"
        ),
        Story(
            name: "Lina",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png",
            localVideoName: "short_4"
        ),
        Story(
            name: "Mark",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png",
            localVideoName: "short_2"
        ),
        Story(
            name: "Anna",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_10.png",
            localVideoName: "short_3"
        ),
        Story(
            name: "Tom",
            avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_1.png",
            localVideoName: nil
        ),
        Story(
            name: "Sara",
            avatarURL: "https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_3.png",
            localVideoName: nil
        ),
        Story(
            name: "Eve",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/bluey_1.png",
            localVideoName: nil
        ),
        Story(
            name: "Mia",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_1.png",
            localVideoName: nil
        ),
        Story(
            name: "Kai",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_5.png",
            localVideoName: nil
        ),
        Story(
            name: "Neo",
            avatarURL:
                "https://cdn.jsdelivr.net/gh/alohe/avatars/png/notion_1.png",
            localVideoName: nil
        ),
    ]

    @State private var seenStories: Set<UUID> = []
    @State private var showingStoryViewer = false
    @State private var selectedStoryIndex: Int? = nil
    @State private var selectedTab: BodyHomeView.Tab = .makeFiends

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

    // Xử lý khi nhấn vào story: mở StoryViewer tại vị trí tương ứng
    // Xử lý khi nhấn vào story: chỉ mở StoryViewer nếu story có video
    private func handleStoryTap(_ story: Story) {
        // nếu không có video thì không làm gì
        guard story.localVideoName != nil else { return }

        // đánh dấu đã xem và lưu
        seenStories.insert(story.id)
        saveSeenStories()

        if let idx = listStories.firstIndex(where: { $0.id == story.id }) {
            selectedStoryIndex = idx
            showingStoryViewer = true
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HomeHeader()
            HomeStory(listStories: listStories, seenStories: seenStories) {
                story in
                handleStoryTap(story)
            }
            BodyHomeView(selectedTab: $selectedTab)

            // Content for selected tab
            Group {
                switch selectedTab {
                case .makeFiends:
                    MakeFriendsView()
                case .searchPartners:
                    SearchPartnersView()
                }
            }
            .padding(.top, 24)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.appBackground)
        .onAppear { loadSeenStories() }
        // mở full-screen StoryViewer
        .fullScreenCover(
            isPresented: $showingStoryViewer,
            onDismiss: {
                selectedStoryIndex = nil
            }
        ) {
            StoryViewer(
                stories: listStories,
                startIndex: selectedStoryIndex ?? 0,
                onClose: { showingStoryViewer = false },
                onSeen: { id in
                    seenStories.insert(id)
                    saveSeenStories()
                }
            )
        }
    }
}

// StoryViewer full-screen: hiển thị video (nếu có trong bundle) với thanh tiến trình ở trên,
// vuốt trái/phải để chuyển người có video, vuốt xuống để đóng. Không hiển thị control hệ thống.
struct StoryViewer: View {
    let stories: [Story]
    @State private var index: Int
    let onClose: () -> Void
    let onSeen: (UUID) -> Void

    @State private var player: AVPlayer? = nil
    @State private var progress: Double = 0.0
    @State private var duration: Double = 5.0
    @State private var isLongPressPaused = false
    @Environment(\.presentationMode) private var presentationMode

    private let timer = Timer.publish(every: 0.05, on: .main, in: .common)
        .autoconnect()

    init(
        stories: [Story],
        startIndex: Int,
        onClose: @escaping () -> Void,
        onSeen: @escaping (UUID) -> Void
    ) {
        self.stories = stories
        self._index = State(initialValue: startIndex)
        self.onClose = onClose
        self.onSeen = onSeen
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                Group {
                    if let local = stories[index].localVideoName,
                        let url = Bundle.main.url(
                            forResource: local,
                            withExtension: "mp4"
                        )
                    {
                        // Sử dụng AVPlayerLayer qua UIViewRepresentable để tránh hiển thị control mặc định của VideoPlayer
                        PlayerContainerView(player: player)
                            .onAppear { startPlayer(url: url) }
                            .onDisappear { stopPlayer() }
                    } else {
                        // fallback: hiển thị avatar lớn
                        KFImage(URL(string: stories[index].avatarURL))
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                // bắt các gesture trên vùng nội dung (tránh chặn nút đóng ở overlay)
                .contentShape(Rectangle())
                .onLongPressGesture(
                    minimumDuration: 0.35,
                    maximumDistance: 10,
                    pressing: { pressing in
                        // giữ để tạm dừng trong lúc giữ
                        isLongPressPaused = pressing
                        updatePlayerPlayState()
                    },
                    perform: {
                        // không cần xử lý khi hoàn tất long-press
                    }
                )
                .highPriorityGesture(
                    TapGesture().onEnded {
                        // tap trên vùng video => chuyển sang story tiếp theo có video
                        next()
                    }
                )
                // overlay trên: tên người + nút đóng + thanh tiến trình
                VStack(spacing: 8) {
                    ProgressView(value: progress)
                        .progressViewStyle(
                            LinearProgressViewStyle(tint: .white)
                        )
                        .frame(height: 2)
                        .padding(.horizontal, 8)

                    HStack {
                        Text(stories[index].name)
                            .foregroundColor(.white)
                            .font(.headline)
                            .lineLimit(1)
                        Spacer()
                        Button(action: { close() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(
                                    Circle().fill(Color.black.opacity(0.35))
                                )
                        }
                    }
                    .padding(.horizontal, 12)

                    Spacer()
                }

            }
            // cử chỉ: vuốt để chuyển, vuốt xuống để đóng (vuốt dùng simultaneous để không chặn Button)
            .simultaneousGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onEnded { value in
                        if abs(value.translation.height) > 100
                            && value.translation.height > 0
                        {
                            // vuốt xuống để đóng
                            close()
                        } else if value.translation.width < -50 {
                            next()
                        } else if value.translation.width > 50 {
                            prev()
                        }
                    }
            )
            // nhấn giữ để tạm dừng trong lúc giữ (sử dụng onLongPressGesture để đảm bảo trạng thái pressing ổn định)
            .onLongPressGesture(
                minimumDuration: 0.35,
                maximumDistance: 10,
                pressing: { pressing in
                    isLongPressPaused = pressing
                    updatePlayerPlayState()
                },
                perform: {
                    // không cần hành động khi hoàn thành long-press
                }
            )
            // nhấn (tap) đã được chuyển xuống content area để chuyển next; không toggle pause ở đây
            .onReceive(timer) { _ in
                tick()
            }
            .onAppear { loadCurrent() }
        }
    }

    private func loadCurrent() {
        progress = 0
        // nếu story hiện tại không có video thì nhảy tới story kế tiếp có video
        if stories[index].localVideoName == nil {
            if let nextIdx = findNextWithVideo(from: index) {
                index = nextIdx
            } else {
                // no more videos, close viewer
                close()
                return
            }
        }

        if let local = stories[index].localVideoName,
            let url = Bundle.main.url(forResource: local, withExtension: "mp4")
        {
            // đánh dấu đã xem
            onSeen(stories[index].id)
            startPlayer(url: url)
        } else {
            // thời lượng mặc định nếu không có video
            duration = 5.0
        }
    }

    private func startPlayer(url: URL) {
        stopPlayer()
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        player?.play()
        // tải duration bất đồng bộ (iOS16+ khuyến nghị)
        duration = 5.0
        Task {
            do {
                let cmTime = try await asset.load(.duration)
                let d = cmTime.seconds
                DispatchQueue.main.async {
                    if d.isFinite {
                        duration = d
                    } else {
                        duration = 5.0
                    }
                }
            } catch {
                // không lấy được duration -> giữ mặc định
            }
        }
    }

    // Cập nhật trạng thái phát theo trạng thái long-press
    private func updatePlayerPlayState() {
        // Nếu đang giữ long-press thì luôn pause
        if isLongPressPaused {
            player?.pause()
            return
        }

        // Ngược lại nếu có player thì phát
        player?.play()
    }

    private func stopPlayer() {
        player?.pause()
        player = nil
    }

    private func tick() {
        if let p = player {
            let current = p.currentTime().seconds
            if duration.isFinite && duration > 0 {
                progress = min(1, current / max(0.001, duration))
                if progress >= 0.999 {
                    next()
                }
            }
        } else {
            // nếu không có video: chạy tiến trình tự động theo timer
            progress += 0.05 / max(0.1, duration)
            if progress >= 1.0 {
                next()
            }
        }
    }

    private func next() {
        stopPlayer()
        if let nextIdx = findNextWithVideo(from: index + 1) {
            index = nextIdx
            loadCurrent()
        } else {
            close()
        }
    }

    private func prev() {
        stopPlayer()
        if let prevIdx = findPrevWithVideo(from: index - 1) {
            index = prevIdx
            loadCurrent()
        } else {
            // không còn video trước đó -> đóng
            close()
        }
    }

    private func findNextWithVideo(from start: Int) -> Int? {
        guard start < stories.count else { return nil }
        var i = start
        while i < stories.count {
            if stories[i].localVideoName != nil { return i }
            i += 1
        }
        return nil
    }

    private func findPrevWithVideo(from start: Int) -> Int? {
        guard start >= 0 else { return nil }
        var i = start
        while i >= 0 {
            if stories[i].localVideoName != nil { return i }
            i -= 1
        }
        return nil
    }

    private func close() {
        stopPlayer()
        onClose()
        presentationMode.wrappedValue.dismiss()
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

                    let hasVideo = (story.localVideoName != nil)
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
                                                .stroke(
                                                    Color.gray.opacity(0.4),
                                                    lineWidth: 3
                                                )
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
            .padding( 16)
          
        
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

// Gradient ring like Instagram
struct StoryGradientRing: View {
    @State private var rotate = false

    var body: some View {
        // AngularGradient rotated over time to create subtle animation
        Circle()
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "0xFFDD88CF"), Color(hex: "0xFF4B164C"),
                        Color(hex: "0xFFFF69B4"), Color(hex: "0xFFDD88CF"),
                    ]),
                    center: .center
                ),
                lineWidth: 3
            )
            .rotationEffect(.degrees(rotate ? 360 : 0))
            .animation(
                .linear(duration: 6).repeatForever(autoreverses: false),
                value: rotate
            )
            .onAppear { rotate = true }
    }
}

// UIViewRepresentable chứa AVPlayerLayer (không có controls) để tránh VideoPlayer hiển thị UI hệ thống
struct PlayerContainerView: UIViewRepresentable {
    let player: AVPlayer?

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.playerLayer.player = player
    }

    class PlayerUIView: UIView {
        let playerLayer = AVPlayerLayer()

        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(playerLayer)
            backgroundColor = .black
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            layer.addSublayer(playerLayer)
            backgroundColor = .black
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
    }
}

struct BodyHomeView: View {
    @Binding var selectedTab: Tab
    enum Tab: String, CaseIterable {
        case makeFiends = "Make Friends"
        case searchPartners = "Search Partners"
    }

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor( .black )
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if selectedTab == tab {
                                    Color.white
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }
                }
            }
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "0xFFF8E7F6"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Tab content views
struct MakeFriendsView: View {
    // sample data
    let people: [(name: String, avatar: String)] = [
        ("Alex", "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png"),
        ("Bella", "https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png"),
        ("Chris", "https://cdn.jsdelivr.net/gh/alohe/avatars/png/bluey_1.png"),
        ("Dana", "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_1.png"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(people, id: \.name) { p in
                    HStack(spacing: 12) {
                        KFImage(URL(string: p.avatar))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.name)
                                .font(.headline)
                                .foregroundColor(Color(hex: "0xFF4B164C"))
                            Text("5 mutual friends")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {}) {
                            Text("Add")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color(hex: "0xFF4B164C"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

struct SearchPartnersView: View {
    @State private var query: String = ""
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Search partners", text: $query)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color(hex: "0xFF4B164C"))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(0..<8) { i in
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(Color(hex: "0xFF4B164C"))
                            Text("User \(i + 1)")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    HomeView()
}
