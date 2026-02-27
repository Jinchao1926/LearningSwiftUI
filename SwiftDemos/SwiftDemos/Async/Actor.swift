//
//  Actor.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/26.
//

import Foundation

// Actor：引用类型 + 自动线程安全
actor BankAccount {
    private var balance: Double = 0.0

    // Actor 内部方法可以同步访问状态
    func deposit(amount: Double) {
        balance += amount
    }

    func withdraw(amount: Double) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }

    var currentBalance: Double { balance }
}

struct BankAccount2 {
    private var balance: Double = 0.0

    mutating func deposit(amount: Double) {
        balance += amount
    }

    mutating func withdraw(amount: Double) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }

    var currentBalance: Double { balance }
}

actor DataCache {
    private var cache: [String: Data] = [:]

    // ✅ Actor 内部可以同步访问
    func get(key: String) -> Data? {
        return cache[key]
    }

    func set(key: String, value: Data) {
        cache[key] = value
    }

    // nonisolated：标记方法不需要 Actor 隔离（不访问可变状态）
    nonisolated func cacheKey(for id: Int) -> String {
        return "key_\(id)"  // 不访问 cache，无需 await
    }
}
