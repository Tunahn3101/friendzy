//
//  Store.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Combine
import SwiftUI

class StoreEnv: ObservableObject {
    var store: Store
    init(store: Store) {
        self.store = store
    }
}

protocol Store {
    func loadInitData(onProgress: ((Double) -> Void)) async throws
    func isirstStart() -> Bool
    func setNoteFirstStart()
    func isLoggedIn() -> Bool
    func setLoggedIn(_ value: Bool)

}
