//
//  LoadStatus.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

enum LoadStatus: Equatable {
    case initial, loading, success
    case failure(msg: String)

}
