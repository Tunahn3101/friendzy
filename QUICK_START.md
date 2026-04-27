# 🚀 Quick Start Guide - Bắt đầu nhanh

## ✅ Setup hoàn tất!

Dự án của bạn đã được setup theo kiến trúc **MVVM** với đầy đủ các thành phần.

## 📂 Những gì đã được tạo:

### Models (Dữ liệu)
- ✅ `User.swift` - Model người dùng
- ✅ `Friend.swift` - Model bạn bè

### ViewModels (Business Logic)
- ✅ `UserViewModel.swift` - Quản lý user state
- ✅ `FriendListViewModel.swift` - Quản lý danh sách bạn bè

### Views (Giao diện)
- ✅ `HomeView.swift` - Trang chủ
- ✅ `FriendListView.swift` - Hiển thị danh sách
- ✅ `AddFriendView.swift` - Thêm bạn mới  
- ✅ `ProfileView.swift` - Trang hồ sơ

### Services
- ✅ `NetworkService.swift` - Service cho API (sẵn sàng dùng sau)

### Utilities
- ✅ `Constants.swift` - Các hằng số
- ✅ `Extensions.swift` - Helper extensions

### Documentation
- ✅ `README.md` - Giới thiệu project
- ✅ `MVVM_GUIDE.md` - Hướng dẫn chi tiết MVVM

## 🎯 Cách chạy:

1. Mở `friendzy.xcodeproj` trong Xcode
2. Chọn simulator (iPhone 15 Pro recommended)
3. Nhấn `Cmd + R` hoặc nút ▶️ Play
4. App sẽ chạy với 2 tabs:
   - **Trang chủ**: Quản lý bạn bè
   - **Hồ sơ**: Thông tin user

## 🎨 Tính năng hiện có:

### Trang chủ (HomeView)
- ✅ Xem danh sách bạn bè
- ✅ Thêm bạn mới (nút + ở góc phải)
- ✅ Tìm kiếm bạn bè
- ✅ Đánh dấu yêu thích (nhấn vào ⭐)
- ✅ Xóa bạn (swipe left)
- ✅ Pull to refresh

### Trang Profile
- ✅ Xem thông tin cá nhân
- ✅ Các menu settings
- ✅ Đăng xuất

### Data Persistence
- ✅ Dữ liệu được lưu trong UserDefaults
- ✅ Tự động load khi mở app lại

## 📖 Cấu trúc code:

```
Khi user nhấn "Thêm bạn":

HomeView (UI)
    ↓ showingAddFriend = true
AddFriendView (Form input)
    ↓ User fills form → tap Save
viewModel.addFriend(...)  (Business Logic)
    ↓ Process & validate
friends.append(newFriend)  (@Published updates)
    ↓ Automatic UI update
FriendListView refreshes  (Display new friend)
```

## 🎓 Học tiếp:

### 1. Đọc code theo thứ tự:
1. `Models/Friend.swift` - Hiểu cấu trúc dữ liệu
2. `ViewModels/FriendListViewModel.swift` - Hiểu logic
3. `Views/FriendListView.swift` - Hiểu cách hiển thị
4. `Views/AddFriendView.swift` - Hiểu forms

### 2. Thử modify:
- Thêm field mới vào Friend (VD: email, address)
- Thêm tính năng sort (sắp xếp theo tên)
- Thêm categories cho friends

### 3. Đọc hướng dẫn:
- `MVVM_GUIDE.md` - Hướng dẫn chi tiết pattern
- `README.md` - Overview dự án

## 💡 Tips cho người mới:

### Khi thêm tính năng mới:

**1. Tự hỏi: "Thành phần nào cần thay đổi?"**
- Cần thêm data? → Model
- Cần xử lý logic? → ViewModel  
- Cần UI mới? → View

**2. Follow the pattern:**
```
Model → ViewModel → View
```

**3. Quan trọng:**
- View KHÔNG chứa logic
- ViewModel KHÔNG biết gì về UI
- Model KHÔNG có logic

## 🔍 Debug tips:

### Print để debug:
```swift
// Trong ViewModel
func addFriend(_ friend: Friend) {
    print("Adding friend: \(friend.name)")  // ← Debug
    friends.append(friend)
    print("Total friends: \(friends.count)")  // ← Debug
}
```

### Check @Published:
Nếu UI không update:
1. ViewModel có kế thừa `ObservableObject`?
2. Property có `@Published`?
3. View dùng `@StateObject` hoặc `@ObservedObject`?

## 📱 UI Components được dùng:

- `NavigationView` - Navigation stack
- `List` - Scrollable list
- `Form` - Input forms
- `TabView` - Bottom tabs
- `Sheet` - Modal presentation
- `TextField` - Text input
- `Toggle` - Switch on/off
- `DatePicker` - Date selection

## 🛠️ Customize:

### Đổi màu chủ đề:
```swift
// Utilities/Constants.swift
enum Colors {
    static let primaryColor = Color.blue  // ← Change here
}
```

### Đổi tab icons:
```swift
// ContentView.swift
.tabItem {
    Label("Trang chủ", systemImage: "house.fill")  // ← Change icon
}
```

### Thêm field mới:
1. Update Model
2. Update ViewModel methods
3. Update View UI

## 🎯 Next Steps:

### Beginner:
- [ ] Chạy app và test các tính năng
- [ ] Đọc từng file code để hiểu
- [ ] Thử thêm 1 friend và xem code chạy

### Intermediate:
- [ ] Thêm field "Email" cho Friend
- [ ] Thêm sort cho friend list
- [ ] Customize colors

### Advanced:
- [ ] Kết nối API thật thay mock data
- [ ] Thêm Core Data thay UserDefaults
- [ ] Thêm authentication flow
- [ ] Add unit tests

## 📞 Cần giúp?

### Common Issues:

**1. "Type X does not conform to ObservableObject"**
- Check: class có `: ObservableObject`?

**2. "UI không update khi data thay đổi"**
- Check: property có `@Published`?
- Check: View dùng `@StateObject`/`@ObservedObject`?

**3. "Cannot find X in scope"**
- Check: import đúng file chưa?
- Check: file đã add vào Xcode project chưa?

### Debug Checklist:
```
✅ Clean Build (Cmd + Shift + K)
✅ Build again (Cmd + B)
✅ Check errors trong Issue Navigator
✅ Restart Xcode nếu cần
```

## 🎉 Chúc mừng!

Bạn đã có một project iOS hoàn chỉnh với:
- ✅ Kiến trúc MVVM chuẩn
- ✅ Code sạch, dễ đọc
- ✅ Sẵn sàng mở rộng
- ✅ Best practices cho người mới

**Keep coding! 💪**

---

### Useful Commands:

```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Reset simulator
xcrun simctl erase all

# Check Swift version
swift --version
```

### Resources:
- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com)
- [SwiftUI by Example](https://www.hackingwithswift.com/quick-start/swiftui)
