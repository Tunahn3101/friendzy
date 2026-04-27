//
//  AddFriendView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import SwiftUI

struct AddFriendView: View {
    @ObservedObject var viewModel: FriendListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var note: String = ""
    @State private var birthday: Date = Date()
    @State private var isFavorite: Bool = false
    @State private var showBirthdayPicker: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin cơ bản")) {
                    TextField("Tên", text: $name)
                    TextField("Số điện thoại", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Thông tin thêm")) {
                    Toggle("Yêu thích", isOn: $isFavorite)
                    
                    Toggle("Thêm ngày sinh", isOn: $showBirthdayPicker)
                    
                    if showBirthdayPicker {
                        DatePicker("Ngày sinh", selection: $birthday, displayedComponents: .date)
                    }
                    
                    TextField("Ghi chú", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Thêm bạn mới")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        saveFriend()
                    }
                    .disabled(name.isEmpty || phoneNumber.isEmpty)
                }
            }
        }
    }
    
    private func saveFriend() {
        let newFriend = Friend(
            name: name,
            phoneNumber: phoneNumber,
            birthday: showBirthdayPicker ? birthday : nil,
            note: note.isEmpty ? nil : note,
            isFavorite: isFavorite
        )
        
        viewModel.addFriend(newFriend)
        dismiss()
    }
}

#Preview {
    AddFriendView(viewModel: FriendListViewModel())
}
