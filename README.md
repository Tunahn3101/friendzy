# Friendzy - Ứng dụng quản lý bạn bè

## 📱 Giới thiệu
Friendzy là ứng dụng iOS giúp bạn quản lý danh sách bạn bè một cách dễ dàng và hiệu quả.

## 🏗️ Kiến trúc MVVM

Dự án này sử dụng kiến trúc **MVVM (Model-View-ViewModel)** - một pattern phổ biến và được khuyên dùng cho SwiftUI.

### Cấu trúc thư mục:

```
friendzy/
├── Models/              # Các data model
│   ├── User.swift
│   └── Friend.swift
│
├── ViewModels/          # Business logic và state management
│   ├── FriendListViewModel.swift
│   └── UserViewModel.swift
│
├── Views/               # Giao diện người dùng
│   ├── HomeView.swift
│   ├── FriendListView.swift
│   ├── AddFriendView.swift
│   └── ProfileView.swift
│
├── Services/            # Các service (API, Database, etc.)
│   └── NetworkService.swift
│
├── Utilities/           # Helpers và Extensions
│   ├── Constants.swift
│   └── Extensions.swift
│
├── ContentView.swift    # Main TabView
└── friendzyApp.swift    # App entry point
```

## 📚 Giải thích MVVM cho người mới

### 1. **Model** (Models/)
- Chứa các cấu trúc dữ liệu (struct/class)
- Đại diện cho dữ liệu trong ứng dụng
- Ví dụ: `User`, `Friend`

### 2. **View** (Views/)
- Là giao diện người dùng (UI)
- Hiển thị dữ liệu từ ViewModel
- Gửi action của người dùng tới ViewModel
- Ví dụ: `HomeView`, `FriendListView`

### 3. **ViewModel** (ViewModels/)
- Là cầu nối giữa Model và View
- Chứa business logic
- Quản lý state (@Published)
- Xử lý các action từ View
- Ví dụ: `FriendListViewModel`, `UserViewModel`

## 🚀 Tính năng chính

- ✅ Xem danh sách bạn bè
- ✅ Thêm bạn mới
- ✅ Xóa bạn
- ✅ Đánh dấu yêu thích
- ✅ Tìm kiếm bạn bè
- ✅ Lưu dữ liệu local (UserDefaults)
- ✅ Profile management

## 🛠️ Công nghệ sử dụng

- **SwiftUI**: Framework UI declarative
- **Combine**: Reactive programming
- **UserDefaults**: Local storage đơn giản
- **MVVM**: Architecture pattern

## 📖 Hướng dẫn sử dụng

### Chạy ứng dụng:
1. Mở `friendzy.xcodeproj` trong Xcode
2. Chọn target device (iPhone simulator)
3. Nhấn Cmd + R để build và run

### Thêm tính năng mới:

1. **Tạo Model mới** trong `Models/`
2. **Tạo ViewModel** trong `ViewModels/` để xử lý logic
3. **Tạo View** trong `Views/` để hiển thị UI
4. **Kết nối** View với ViewModel bằng `@StateObject` hoặc `@ObservedObject`

## 💡 Tips cho người mới học

1. **@Published**: Biến này khi thay đổi sẽ tự động cập nhật UI
2. **@StateObject**: Dùng để khởi tạo ViewModel lần đầu
3. **@ObservedObject**: Dùng để nhận ViewModel từ parent view
4. **@State**: Dùng cho local state trong View
5. **@Binding**: Dùng để pass data 2-way giữa parent và child

## 🔄 Flow hoạt động

```
User Action (View) 
    ↓
ViewModel (xử lý logic)
    ↓
Update @Published property
    ↓
View tự động refresh
```

## 📝 TODO - Các tính năng có thể thêm

- [ ] Kết nối API thật (thay mock data)
- [ ] Sử dụng Core Data thay UserDefaults
- [ ] Thêm authentication
- [ ] Upload/hiển thị ảnh avatar thật
- [ ] Thêm categories cho friends
- [ ] Push notifications
- [ ] Share friend contact
- [ ] Dark mode support

## 📞 Liên hệ

Nếu có câu hỏi, vui lòng tạo issue trong repository.

---

**Chúc bạn code vui vẻ! 🎉**
