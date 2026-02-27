//
//  AsyncView.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/27.
//

import SwiftUI

struct AsyncView: View {
    private let account = BankAccount()
    private let cache = DataCache()
    
    var body: some View {
        List {
            Button("Test Actor") {
                testActor()
            }
            Button("Test Non Actor") {
                testNonActor()
            }
            Button("Test Actor Nonisolated") {
                testActorNonisolated()
            }
        }
    }
    
    private func testActor() {
        // 外部访问必须 await（进入 Actor 的"串行执行区"）
        // 两个 Task 不会并发访问 balance，Actor 保证串行执行
        Task { await account.deposit(amount: 100) }
        Task { await account.deposit(amount: 200) }
        Task {
            let balance = await account.currentBalance
            debugPrint("current balance:", balance)
        }
    }
    
    private func testNonActor() {
        // account2 是 @MainActor 隔离的属性，Task.detached 不继承 MainActor 上下文，编译器直接拒绝
        var account2 = BankAccount2()
        Task.detached { account2.deposit(amount: 100) }
        Task.detached { account2.deposit(amount: 200) }
        Task.detached {
            let balance = account2.currentBalance
            debugPrint("current balance:", balance)
        }
    }
    
    private func testActorNonisolated() {
        // 外部访问需要 await
        Task {
            let key = cache.cacheKey(for: 1)  // nonisolated，无需 await
            await cache.set(key: key, value: Data())
            let _ = await cache.get(key: key)
            debugPrint("cache key:", key)
        }
    }
}

#Preview {
    AsyncView()
}
