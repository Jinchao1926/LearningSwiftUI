//
//  ProductViewModel.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/27.
//

import Foundation
import Combine

// 第一步：定义遵循 ObservableObject 的类（状态存储载体）
class LoginViewModel: ObservableObject {
    // 第二步：用 @Published 标记需要监听的属性（触发通知）
    @Published var isLogined: Bool = false
    @Published var user: User?
    
    func login() {
        // 修改 @Published 属性 → 自动发送通知
        isLogined = true
        user = User(id: 9527, name: "唐伯虎")
    }
}

struct User: CustomStringConvertible {
    var id: Int
    var name: String
    
    var description: String {
        return "id: \(id) name: \(name)"
    }
}

class AppStore: ObservableObject {
    let version = "1.0.0"
}


enum Theme {
    case dark
    case light
}

class AppState: ObservableObject {
    @Published var theme: Theme = .light
}
