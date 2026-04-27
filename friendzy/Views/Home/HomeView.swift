//
//  HomeView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct HomeView: View {
    // 🎯 @StateObject: Kết hợp SwiftUI + Combine
    // - Tạo và sở hữu ViewModel
    // - Tự động SUBSCRIBE vào tất cả @Published properties của ViewModel
    // - Khi @Published thay đổi → View này TỰ ĐỘNG re-render
    @StateObject private var viewModel = FriendListViewModel()
    
    // 🎯 @State: SwiftUI state (không phải Combine)
    // - Chỉ dùng cho UI state đơn giản trong View
    @State private var showingAddFriend = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 📡 viewModel.isLoading là @Published property
                // → Khi isLoading thay đổi, View này TỰ ĐỘNG re-render
                if viewModel.isLoading {
                    ProgressView("Đang tải...")
                } else {
                    // Pass ViewModel xuống child view
                    // Child view dùng @ObservedObject để observe
                    FriendListView(viewModel: viewModel)
                }
            }
            .navigationTitle("Friendzy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddFriend = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddFriend) {
                AddFriendView(viewModel: viewModel)
            }
        }
    }
}

/*
 ═══════════════════════════════════════════════════════════════════════════
 🧪 THỬ NGHIỆM ĐỂ HIỂU COMBINE
 ═══════════════════════════════════════════════════════════════════════════
 
 1. Thêm print để xem Combine hoạt động:
 
 Trong FriendListViewModel.swift, thêm:
 ```swift
 @Published var friends: [Friend] = [] {
     didSet {
         print("🔔 Combine: friends changed! Count: \(friends.count)")
     }
 }
 ```
 
 2. Chạy app và thêm friend → Xem console:
    🔔 Combine: friends changed! Count: 1
    (SwiftUI tự động update UI ngay sau đó)
 
 3. Không cần gọi bất kỳ hàm update UI nào!
 
 ═══════════════════════════════════════════════════════════════════════════
 ❓ CÂU HỎI THƯỜNG GẶP
 ═══════════════════════════════════════════════════════════════════════════
 
 Q: Có bắt buộc phải import Combine không?
 A: Có! Vì ObservableObject và @Published đều đến từ Combine framework.
 
 Q: SwiftUI có thể hoạt động mà không có Combine không?
 A: Có, nhưng mất đi tính năng reactive powerful. @State vẫn dùng được.
 
 Q: Khi nào dùng @Published?
 A: Khi muốn UI tự động update khi data thay đổi.
 
 Q: @Published có tốn performance không?
 A: Rất ít. Apple đã optimize rất tốt. Chỉ render lại View cần thiết.
 
 Q: Có thể dùng Combine với UIKit không?
 A: Có! Nhưng phải code nhiều hơn, không tự động như SwiftUI.
 
 ═══════════════════════════════════════════════════════════════════════════
*/

#Preview {
    HomeView()
}

/*
 💡 TÓM TẮT CHO NGƯỜI MỚI:
 ════════════════════════════════════════════════════════════════════════════
 
 Combine = Framework giúp DATA và UI luôn ĐỒNG BỘ tự động
 
 @Published var x = 1     →  x thay đổi
                             ↓ (Combine gửi signal)
 @StateObject viewModel   →  View nhận signal
                             ↓
 body re-render           →  UI hiển thị giá trị mới
 
 ✨ MỌI THỨ TỰ ĐỘNG! Code ngắn gọn, ít bug, dễ maintain!
 
 ════════════════════════════════════════════════════════════════════════════
*/
