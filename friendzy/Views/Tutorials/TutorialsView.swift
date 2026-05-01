//
//  TutorialsView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Combine
import SwiftUI

struct TutorialsView: View {
    @EnvironmentObject var storeEnv: StoreEnv
    @State private var navigateToNext = false
    @State private var currentIndex = 0

    private let images = [
        "shared_moments",
        "sunset_stroll",
        "the_meeting",
    ]

  
    private let featureItems: [ItemCore] = [
        ItemCore(icon: "heart.fill", text: "Find Love"),
        ItemCore(icon: "message.fill", text: "Chat Instantly", color: .blue),
        ItemCore(icon: "star.fill", text: "Premium Features", color: .orange),
//        ItemCore(icon: "person.2.fill", text: "Meet Friends", color: .green),
//        ItemCore(icon: "sparkles", text: "AI Matching", color: .purple),
    ]

    private let timer = Timer.publish(every: 2.5, on: .main, in: .common)
        .autoconnect()

    init() {

        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(
            red: 0.867,
            green: 0.533,
            blue: 0.812,
            alpha: 1.0
        )
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray3
            .withAlphaComponent(0.5)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                // Layer 1: TabView (ẨN dots mặc định)
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))  // ✅ ẨN dots mặc định

                // Layer 2: Gradient overlay ở bottom
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,  // Trắng đậm ở dưới cùng
                        Color.white.opacity(0.9),  // Trắng nhạt
                        Color.white.opacity(0.5),  // Mờ dần
                        Color.clear,  // Trong suốt ở trên
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 200)  // Chiều cao lớp mờ
                .allowsHitTesting(false)  // Không chặn touch events

                // Layer 3: Custom Dots Indicator (TRÊN gradient)
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        // viên thuốc
                        Capsule()
                            .fill(
                                currentIndex == index
                                    ? Color.appPrimary  // ✅ Dùng màu base
                                    : Color.gray.opacity(0.5)
                            )  // Inactive - xám nhạt
                            .frame(
                                width: currentIndex == index ? 24 : 8,
                                height: 8
                            )
                            .animation(
                                .easeInOut(duration: 0.3),
                                value: currentIndex
                            )
                    }
                }
                .padding(.bottom, 20)  // Khoảng cách từ bottom
            }
            .frame(height: 400)

            VStack(spacing: 20) {

                VStack(spacing: 4) {
                    Text("Find Your")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Soulmate 💗")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.appPrimary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

                Text(
                    "Connect with people who share your interests and values. Your perfect match is just a swipe away."
                )
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)  // Căn giữa
                .lineSpacing(4)  // Khoảng cách giữa các dòng
                .padding(.horizontal, 20)  //  Padding 2 bên

                HorizontalItemCarousel(items: featureItems)
                    // ✅ Không cố định height, để auto resize theo số dòng

                // Button để skip/continue
                Button(action: {
                    // Đánh dấu đã xem tutorials
                    storeEnv.store.setNoteFirstStart()
                    // Navigate đến màn tiếp theo
                    navigateToNext = true
                }) {
                
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimary)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            .padding()

            Spacer()
        }
        .onReceive(timer) { _ in
            //  Timer sẽ trigger block này
            currentIndex = (currentIndex + 1) % images.count
        }
        .navigationDestination(isPresented: $navigateToNext) {
            // Sau khi xem tutorials → check login
            if storeEnv.store.isLoggedIn() {
                TabbarView()  // ✅ Navigate to TabbarView instead of HomeView
            } else {
                LoginView()
            }
        }
        .navigationBarBackButtonHidden(true)  // Ẩn back button
    }
}


// Model cho các mục trong carousel nằm ngang
struct ItemCore: Identifiable {
    let id = UUID()
    let icon: String  // SF Symbol name (vd: "heart.fill")
    let text: String  // Text mô tả
    let color: Color  // Màu cho icon (optional, có thể bỏ)

    // Khởi tạo đơn giản
    init(icon: String, text: String, color: Color = .appPrimary) {
        self.icon = icon
        self.text = text
        self.color = color
    }
}



// Layout tự động wrap items khi hết chỗ, căn giữa
struct WrappingHStack<Content: View>: View {
    let content: () -> Content
    let spacing: CGFloat
    
    @State private var totalHeight: CGFloat = 0
    
    init(spacing: CGFloat = 12, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            // Measure và render children
            ForEach(Array(zip(getChildren(), getChildren().indices)), id: \.1) { child, index in
                child
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= lineHeight
                            lineHeight = 0
                        }
                        let result = width
                        if index == getChildren().count - 1 {
                            width = 0
                        } else {
                            width -= dimension.width + spacing
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        lineHeight = max(lineHeight, dimension.height)
                        return result
                    }
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(HeightPreferenceKey.self) { value in
            totalHeight = value
        }
    }
    
    private func getChildren() -> [AnyView] {
        var children: [AnyView] = []
        let mirror = Mirror(reflecting: content())
        
        for child in mirror.children {
            if let view = child.value as? AnyView {
                children.append(view)
            }
        }
        
        return children
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct HorizontalItemCarousel: View {
    let items: [ItemCore]
    
    var body: some View {
        
        FlowLayout(spacing: 12) {
            ForEach(items) { item in
                HStack(spacing: 8) {
                    // Icon nhỏ
                    Image(systemName: item.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(item.color)
                    
                    // Text
                    Text(item.text)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(item.color.opacity(0.12))
                )
                .overlay(
                    Capsule()
                        .stroke(item.color.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 12
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let layout = computeLayout(proposal: proposal, subviews: subviews)
        
        for (index, position) in layout.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }
    
    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var positions: [CGPoint] = []
        var lines: [[Int]] = [[]]
        var lineWidths: [CGFloat] = [0]
        
        // First pass: compute positions and group into lines
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth && currentX > 0 {
                // New line
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
                lines.append([])
                lineWidths.append(0)
            }
            
            lines[lines.count - 1].append(index)
            lineWidths[lines.count - 1] += size.width + (currentX > 0 ? spacing : 0)
            
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        // Second pass: center each line and place views
        currentY = 0
        lineHeight = 0
        var lineIndex = 0
        
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            
            if !lines[lineIndex].contains(index) {
                lineIndex += 1
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            // Center offset for this line
            let lineWidth = lineWidths[lineIndex]
            let centerOffset = (maxWidth - lineWidth) / 2
            
            let positionInLine = lines[lineIndex].firstIndex(of: index) ?? 0
            var lineX: CGFloat = centerOffset
            
            for i in 0..<positionInLine {
                let prevIndex = lines[lineIndex][i]
                lineX += subviews[prevIndex].sizeThatFits(.unspecified).width + spacing
            }
            
            positions.append(CGPoint(x: lineX, y: currentY))
            lineHeight = max(lineHeight, size.height)
        }
        
        let totalHeight = currentY + lineHeight
        return (CGSize(width: maxWidth, height: totalHeight), positions)
    }
}
