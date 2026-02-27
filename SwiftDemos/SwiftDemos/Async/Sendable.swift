//
//  Sendable.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/27.
//

import Foundation

// =============================================================================
// Sendable 协议
//
// 作用：标记一个类型可以"安全地跨并发边界传递"（跨线程/Actor/Task 传递）
//
// 核心问题：当数据在多个线程之间共享时，可变引用类型会导致数据竞争（data race）。
// Sendable 让编译器在编译期检查哪些类型可以安全传递，而不是在运行时崩溃。
//
// 规则：
//   ✅ 满足 Sendable → 可以跨并发边界传递
//   ❌ 不满足 Sendable → 编译器报警告/错误，阻止不安全的跨边界传递
// =============================================================================


// MARK: - 1. 值类型自动满足 Sendable（所有存储属性也是 Sendable）
//
// struct/enum 是值类型，跨边界时会复制，天然无数据竞争
// 编译器自动推断，无需显式声明（显式声明是为了可读性/文档化）

struct UserInfo: Sendable {
    let id: Int
    let name: String
}

// enum 同理，关联值也必须是 Sendable
enum TaskStatus: Sendable {
    case pending
    case running(progress: Double)  // Double 是 Sendable ✅
    case completed(result: String)  // String 是 Sendable ✅
    case failed(Error)              // Error 隐式 Sendable ✅
}


// MARK: - 2. class 需要满足额外条件才能声明 Sendable

// ✅ final class + 所有属性均为 let（不可变）→ 编译器允许声明 Sendable
final class AppConfig: Sendable {
    let timeout: TimeInterval = 30
    let baseURL: String = "https://api.example.com"
    let maxRetries: Int = 3
}

// ❌ 有 var 属性的 class 不能声明 Sendable，编译器会报错：
 final class MutableConfig: Sendable {
     var timeout: Int = 30  // ❌ stored property 'timeout' of 'Sendable'-conforming class is mutable
 }


// MARK: - 3. @unchecked Sendable：手动承诺线程安全，跳过编译器检查
//
// 场景：class 内部有 var（可变状态），但已通过锁/队列等机制保证线程安全
// 开发者需要自己保证正确性，编译器不再检查

final class SyncCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var count = 0

    func increment() {
        lock.withLock { count += 1 }
    }

    func decrement() {
        lock.withLock { count -= 1 }
    }

    var value: Int {
        lock.withLock { count }
    }
}


// MARK: - 4. @Sendable 闭包：标记闭包本身可跨并发边界传递
//
// Task / Task.detached 的 operation 参数类型就是 @Sendable 闭包
// @Sendable 要求：闭包捕获的所有变量也必须是 Sendable

// 自定义接受 @Sendable 闭包的函数
func runConcurrently(times: Int, work: @Sendable @escaping () -> Void) {
    for _ in 0..<times {
        Task.detached { work() }
    }
}


// MARK: - 5. 泛型约束 <T: Sendable>：只接受可跨并发边界传递的类型
//
// 场景：封装一个"安全传值到后台处理"的工具函数

func process<T: Sendable>(_ value: T, handler: @Sendable @escaping (T) -> Void) {
    Task.detached {
        handler(value)  // 编译器保证 value 和 handler 都是 Sendable，跨边界安全
    }
}


// MARK: - 6. actor 天然是 Sendable
//
// actor 是引用类型，但通过内置串行化机制保证线程安全
// 因此 actor 自动隐式符合 Sendable，可以跨边界传递 actor 的引用

actor MessageQueue {
    private var messages: [String] = []

    func enqueue(_ message: String) {
        messages.append(message)
    }

    func dequeue() -> String? {
        messages.isEmpty ? nil : messages.removeFirst()
    }

    var count: Int { messages.count }
}

// 可以将 actor 引用传递给 Task.detached，因为 actor 是 Sendable
func passActorAcrossBoundary(queue: MessageQueue) {
    Task.detached {
        await queue.enqueue("Hello from detached task")  // ✅ actor 引用可跨边界
    }
}
