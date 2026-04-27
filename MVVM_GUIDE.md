# Hướng dẫn chi tiết về kiến trúc MVVM cho người mới

## 🎯 Tại sao chọn MVVM?

### So sánh MVVM vs MVC:

**MVC (Model-View-Controller):**
- Controller chứa quá nhiều logic → khó test, khó maintain
- View phụ thuộc trực tiếp vào Model
- Không tối ưu cho SwiftUI

**MVVM (Model-View-ViewModel):** ✅ ĐƯỢC CHỌN
- Tách biệt logic rõ ràng
- Dễ test (test được ViewModel mà không cần UI)
- Hoàn hảo cho SwiftUI với @Published và Combine
- View chỉ hiển thị, không chứa logic
- Code dễ đọc, dễ maintain

## 📁 Cấu trúc Project

```
friendzy/
│
├── 📂 Models/                      # Lớp 1: Dữ liệu
│   ├── User.swift                  # Model cho người dùng
│   └── Friend.swift                # Model cho bạn bè
│
├── 📂 ViewModels/                  # Lớp 2: Business Logic
│   ├── UserViewModel.swift         # Xử lý logic user
│   └── FriendListViewModel.swift   # Xử lý logic danh sách bạn
│
├── 📂 Views/                       # Lớp 3: Giao diện
│   ├── HomeView.swift              # Màn hình chính
│   ├── FriendListView.swift        # Danh sách bạn bè
│   ├── AddFriendView.swift         # Thêm bạn mới
│   └── ProfileView.swift           # Hồ sơ người dùng
│
├── 📂 Services/                    # Lớp 4: Services
│   └── NetworkService.swift        # API calls, network
│
├── 📂 Utilities/                   # Lớp 5: Helpers
│   ├── Constants.swift             # Hằng số
│   └── Extensions.swift            # Extension helpers
│
├── ContentView.swift               # Root view (TabView)
└── friendzyApp.swift               # Entry point
```

## 🔄 Flow hoạt động của MVVM

```
┌──────────────┐
│    VIEW      │ 1. User taps button
│ (HomeView)   │ ───────────────┐
└──────────────┘                │
       ↑                        ↓
       │                ┌──────────────┐
       │ 4. UI Update   │  ViewModel   │ 2. Process logic
       │   (auto)       │(FriendList   │    Add/Delete
       │                │ ViewModel)   │    Update @Published
       │                └──────────────┘
       │                        ↓
       │                ┌──────────────┐
       └────────────────│    MODEL     │ 3. Update data
                        │  (Friend)    │
                        └──────────────┘
```

## 📝 Chi tiết từng thành phần

### 1. MODEL (Models/)

**Nhiệm vụ:**
- Định nghĩa cấu trúc dữ liệu
- Không chứa logic
- Chỉ là struct/class đơn giản

**Ví dụ - Friend.swift:**
```swift
struct Friend: Identifiable, Codable {
    let id: UUID              // ID duy nhất
    var name: String          // Tên
    var phoneNumber: String   // SĐT
    var isFavorite: Bool      // Yêu thích?
}
```

**Khi nào tạo Model mới?**
- Khi có đối tượng dữ liệu mới (VD: Message, Event, Post...)

---

### 2. VIEWMODEL (ViewModels/)

**Nhiệm vụ:**
- Chứa business logic
- Quản lý state (trạng thái)
- Giao tiếp với Model và Services
- Cung cấp data cho View

**Key concepts:**

#### `@Published`
Khi biến này thay đổi → View tự động update
```swift
@Published var friends: [Friend] = []  
// Khi friends thay đổi → FriendListView tự động hiển thị mới
```

#### `ObservableObject`
Protocol cho phép ViewModel notify View khi có thay đổi
```swift
class FriendListViewModel: ObservableObject {
    @Published var friends: [Friend] = []
}
```

**Ví dụ - FriendListViewModel.swift:**
```swift
class FriendListViewModel: ObservableObject {
    // State
    @Published var friends: [Friend] = []
    @Published var searchText: String = ""
    
    // Computed property
    var filteredFriends: [Friend] {
        // Logic filter bạn bè theo searchText
    }
    
    // Methods - Business logic
    func addFriend(_ friend: Friend) {
        friends.append(friend)
        saveFriends()  // Lưu vào storage
    }
    
    func deleteFriend(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
        saveFriends()
    }
}
```

**Khi nào tạo ViewModel mới?**
- Mỗi màn hình phức tạp cần 1 ViewModel
- Khi có logic riêng biệt cần quản lý

---

### 3. VIEW (Views/)

**Nhiệm vụ:**
- Hiển thị UI
- Nhận input từ user
- Gọi methods từ ViewModel
- KHÔNG chứa business logic

**Key concepts:**

#### `@StateObject`
Khởi tạo ViewModel lần đầu - View sở hữu ViewModel
```swift
@StateObject private var viewModel = FriendListViewModel()
```

#### `@ObservedObject`
Nhận ViewModel từ parent - Không sở hữu
```swift
@ObservedObject var viewModel: FriendListViewModel
```

#### `@State`
Local state trong View - chỉ dùng cho UI state đơn giản
```swift
@State private var showingAddFriend = false
```

#### `@Binding`
Two-way binding giữa parent và child
```swift
@Binding var isPresented: Bool
```

**Ví dụ - HomeView.swift:**
```swift
struct HomeView: View {
    @StateObject private var viewModel = FriendListViewModel()
    @State private var showingAddFriend = false
    
    var body: some View {
        NavigationView {
            FriendListView(viewModel: viewModel)  // Pass ViewModel
                .toolbar {
                    Button("Add") {
                        showingAddFriend = true  // UI state
                    }
                }
        }
    }
}
```

**Quy tắc:**
- View chỉ display và forward action
- Mọi logic phải ở ViewModel
- Dùng @StateObject cho owner, @ObservedObject cho receiver

---

### 4. SERVICES (Services/)

**Nhiệm vụ:**
- API calls
- Database operations
- External services

**Ví dụ - NetworkService.swift:**
```swift
class NetworkService {
    static let shared = NetworkService()
    
    func fetch<T: Decodable>(from url: String) async throws -> T {
        // API logic
    }
}
```

**Khi nào dùng?**
- Call API
- Lưu/đọc từ database
- Authentication

---

### 5. UTILITIES (Utilities/)

**Nhiệm vụ:**
- Helper functions
- Extensions
- Constants

**Ví dụ:**
```swift
// Constants.swift
enum AppConstants {
    static let apiURL = "https://api.example.com"
}

// Extensions.swift
extension Date {
    func toString() -> String {
        // Format date
    }
}
```

---

## 🎓 Workflow: Thêm tính năng mới

### Ví dụ: Thêm tính năng "Ghi chú cho bạn bè"

**Bước 1: Update Model**
```swift
// Models/Friend.swift
struct Friend {
    // ...existing code...
    var notes: String?  // ← Thêm field mới
}
```

**Bước 2: Update ViewModel**
```swift
// ViewModels/FriendListViewModel.swift
class FriendListViewModel {
    func updateNote(for friend: Friend, note: String) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index].notes = note
            saveFriends()
        }
    }
}
```

**Bước 3: Update View**
```swift
// Views/FriendDetailView.swift
struct FriendDetailView: View {
    @ObservedObject var viewModel: FriendListViewModel
    let friend: Friend
    @State private var noteText = ""
    
    var body: some View {
        TextField("Ghi chú", text: $noteText)
            .onSubmit {
                viewModel.updateNote(for: friend, note: noteText)
            }
    }
}
```

---

## ✅ Best Practices

### 1. Naming Convention
- Models: `User`, `Friend` (noun)
- ViewModels: `UserViewModel`, `FriendListViewModel` 
- Views: `HomeView`, `ProfileView`

### 2. File Organization
- Mỗi class/struct một file riêng
- Group files theo thư mục logic

### 3. Separation of Concerns
```
❌ BAD - Logic trong View:
struct HomeView: View {
    var body: some View {
        Button("Add") {
            let friend = Friend(...)  // ← Logic trong View!
            friends.append(friend)
        }
    }
}

✅ GOOD - Logic trong ViewModel:
struct HomeView: View {
    @StateObject var viewModel = FriendListViewModel()
    
    var body: some View {
        Button("Add") {
            viewModel.addFriend(...)  // ← Call ViewModel
        }
    }
}
```

### 4. Use Computed Properties
```swift
// ViewModel
var favoriteFriends: [Friend] {
    friends.filter { $0.isFavorite }
}
// Không cần @Published vì phụ thuộc vào friends
```

---

## 🐛 Common Mistakes

### 1. Không dùng @Published
```swift
❌ var friends: [Friend] = []  // View không update!
✅ @Published var friends: [Friend] = []
```

### 2. Dùng sai @StateObject vs @ObservedObject
```swift
❌ @StateObject var viewModel: FriendListViewModel  // Parent pass vào
✅ @ObservedObject var viewModel: FriendListViewModel

❌ @ObservedObject private var viewModel = FriendListViewModel()  // Khởi tạo mới
✅ @StateObject private var viewModel = FriendListViewModel()
```

### 3. Logic trong View
```swift
❌ View chứa business logic
✅ View chỉ display và forward action
```

---

## 📚 Learning Path

1. **Week 1-2:** Hiểu Models và Views cơ bản
2. **Week 3-4:** Học ViewModels và @Published
3. **Week 5-6:** Services và API integration
4. **Week 7+:** Advanced patterns, testing

---

## 🔗 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Combine Framework](https://developer.apple.com/documentation/combine)
- [MVVM Pattern](https://www.raywenderlich.com/books/swiftui-by-tutorials)

---

**Happy Coding! 🚀**
