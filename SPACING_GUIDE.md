# 📏 SwiftUI Spacing Guide - So Sánh với Flutter

## TÓM TẮT NHANH

### Flutter → SwiftUI

| Flutter | SwiftUI | Ghi chú |
|---------|---------|---------|
| `SizedBox(height: 20)` | `SizedBox(height: 20)` | Dùng helper đã tạo |
| `SizedBox(height: 20)` | `Spacer(minLength: 20)` | Native SwiftUI |
| `SizedBox(height: 20)` | `Color.clear.frame(height: 20)` | Cách khác |
| `Spacer()` | `Spacer()` | Giống y Flutter! |
| `Padding(...)` | `.padding(...)` | Tương tự |
| `Column(spacing: 10)` | `VStack(spacing: 10)` | Giống nhau |

## 5 CÁCH TẠO SPACING TRONG SWIFTUI

### 1️⃣ VStack(spacing: ...) - ĐỀU CHO TẤT CẢ
```swift
VStack(spacing: 20) {
    Text("A")
    Text("B")  // 20pt space
    Text("C")  // 20pt space
}
```

**Khi nào dùng:** Khi tất cả khoảng cách giống nhau

### 2️⃣ Spacer() - FLEXIBLE SPACE
```swift
VStack {
    Text("Top")
    Spacer()  // Lấy hết space còn lại
    Text("Bottom")
}
```

**Khi nào dùng:** Đẩy views ra xa nhau, center content

### 3️⃣ Spacer(minLength: ...) - TỐI THIỂU
```swift
VStack(spacing: 0) {
    Text("A")
    Spacer(minLength: 20)  // Tối thiểu 20pt, có thể lớn hơn
    Text("B")
}
```

**Khi nào dùng:** Muốn khoảng cách tối thiểu nhưng vẫn flexible

### 4️⃣ .padding() - XUNG QUANH VIEW
```swift
VStack(spacing: 0) {
    Text("A")
        .padding(.bottom, 20)  // Thêm 20pt phía dưới
    Text("B")
}
```

**Khi nào dùng:** Muốn control chính xác từng view

### 5️⃣ SizedBox - GIỐNG FLUTTER
```swift
VStack {
    Text("A")
    SizedBox(height: 20)  // Chính xác 20pt
    Text("B")
}
```

**Khi nào dùng:** Đã quen Flutter, muốn syntax giống

## VÍ DỤ THỰC TẾ

### ✅ Tốt - Khoảng cách đều
```swift
VStack(spacing: 16) {
    ForEach(friends) { friend in
        FriendRow(friend: friend)
    }
}
```

### ✅ Tốt - Custom từng khoảng
```swift
VStack(spacing: 0) {
    Header()
        .padding(.bottom, 30)
    
    Content()
        .padding(.bottom, 20)
    
    Footer()
}
```

### ✅ Tốt - Center content
```swift
VStack {
    Spacer()
    
    Logo()
    Title()
    
    Spacer()
}
```

### ❌ Tránh - Redundant spacing
```swift
// Không cần thiết!
VStack(spacing: 20) {
    Text("A")
        .padding(.bottom, 20)  // ← Thừa, đã có spacing: 20
    Text("B")
}
```

## CHEAT SHEET

```swift
// Vertical spacing
VStack(spacing: 10) { ... }
SizedBox(height: 10)
Spacer(minLength: 10)
.padding(.vertical, 10)

// Horizontal spacing
HStack(spacing: 10) { ... }
SizedBox(width: 10)
Spacer(minLength: 10)
.padding(.horizontal, 10)

// Center vertically
VStack {
    Spacer()
    Content()
    Spacer()
}

// Push to top
VStack {
    Content()
    Spacer()
}

// Push to bottom
VStack {
    Spacer()
    Content()
}
```

## TIPS

1. **Start simple:** Dùng `VStack(spacing:)` trước, custom sau nếu cần
2. **Be consistent:** Dùng same spacing value trong toàn app (8, 16, 24, 32)
3. **Use constants:** Tạo spacing constants để dễ maintain
   ```swift
   enum Spacing {
       static let small: CGFloat = 8
       static let medium: CGFloat = 16
       static let large: CGFloat = 24
   }
   ```
4. **Preview often:** Dùng Preview để xem spacing trực quan
5. **Responsive:** Consider device size cho spacing values

## FILE TRONG PROJECT

- `SplashView.swift` - Ví dụ đầy đủ với comments
- `SizedBox.swift` - Helper giống Flutter
- File này - Quick reference

---

**Happy Spacing! 🎨**
