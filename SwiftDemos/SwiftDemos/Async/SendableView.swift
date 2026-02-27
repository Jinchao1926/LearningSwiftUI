//
//  SendableView.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/27.
//

import SwiftUI

struct SendableView: View {
    private let counter = SyncCounter()
    private let queue = MessageQueue()

    var body: some View {
        List {
            Section("Demo 1: Sendable struct 跨 Task 传递") {
                Button("Run") { testSendableStruct() }
            }

            Section("Demo 2: @unchecked Sendable 并发写入") {
                Button("Run") { testUncheckedSendable() }
            }

            Section("Demo 3: @Sendable 闭包") {
                Button("Run") { testSendableClosure() }
            }

            Section("Demo 4: 泛型 <T: Sendable>") {
                Button("Run") { testGenericSendable() }
            }

            Section("Demo 5: actor 引用跨边界传递") {
                Button("Run") { testActorSendable() }
            }
        }
        .navigationTitle("Sendable")
    }

    // MARK: - Demo 1
    // UserInfo 是 Sendable struct，可以安全传入 Task.detached（跨并发边界）
    private func testSendableStruct() {
        let user = UserInfo(id: 1, name: "Alice")

        // ✅ user 是 Sendable，可以安全传入 detached task
        Task.detached {
            // 这里是独立线程，user 已被值拷贝，不存在共享状态
            debugPrint("User in detached task: \(user.name) (id=\(user.id))")
        }
    }

    // MARK: - Demo 2
    // SyncCounter 用 NSLock 内部保护可变状态，声明为 @unchecked Sendable
    // 多个并发 Task 同时写入，不会产生数据竞争
    private func testUncheckedSendable() {
        let group = DispatchGroup()

        for i in 1...5 {
            group.enter()
            Task.detached { [counter] in
                await counter.increment()
                await debugPrint("Task \(i) incremented → counter = \(counter.value)")
                group.leave()
            }
        }

        group.notify(queue: .main) {
            Task { debugPrint("Final counter value = \(counter.value)") }
        }
    }

    // MARK: - Demo 3
    // @Sendable 闭包：捕获的变量必须是 Sendable
    // runConcurrently 接受 @Sendable 闭包，确保闭包跨 Task 传递是安全的
    private func testSendableClosure() {
        let prefix = "Hello"  // String 是 Sendable ✅

        runConcurrently(times: 3) {
            // prefix 是 Sendable，可以安全在 @Sendable 闭包中捕获
            Task { debugPrint("\(prefix) from @Sendable closure") }
        }
    }

    // MARK: - Demo 4
    // 泛型 <T: Sendable>：编译器静态保证传入类型可跨边界
    private func testGenericSendable() {
        let status = TaskStatus.running(progress: 0.75)

        process(status) { received in
            Task { debugPrint("Received status: \(received)") }
        }

        process(AppConfig()) { config in
            Task { debugPrint("Config baseURL: \(config.baseURL)") }
        }
    }

    // MARK: - Demo 5
    // actor 隐式满足 Sendable，可以跨 Task 传递 actor 引用
    // 多个 Task 并发调用 actor 方法，actor 内部自动串行化
    private func testActorSendable() {
        // 将 actor 引用传入 detached task — actor 是 Sendable ✅
        Task.detached { [queue] in
            await queue.enqueue("Message A")
            await queue.enqueue("Message B")
            let count = await queue.count
            debugPrint("Enqueued 2 messages, queue count = \(count)")
        }

        Task.detached { [queue] in
            // 即使两个 detached task 同时访问，actor 也保证串行执行
            await queue.enqueue("Message C")
            let msg = await queue.dequeue()
            debugPrint("Dequeued: \(msg ?? "nil")")
        }
    }
}

#Preview {
    NavigationStack {
        SendableView()
    }
}
