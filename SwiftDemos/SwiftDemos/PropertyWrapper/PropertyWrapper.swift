//
//  PropertyWrapper.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/25.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        nonmutating set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    // 通过 $ 访问
    var projectedValue: AnyPublisher<T, Never> {
        /// publisher(for:) 是 Combine 的 KVO Publisher，\.self 表示观察 UserDefaults 对象本身。
        /// 但 UserDefaults.standard 是单例，对象引用永远不变，KVO 只在订阅时触发一次初始值，之后不再触发
//        UserDefaults.standard
//            .publisher(for: \.self)          // 监听整个 UserDefaults
//            .compactMap { $0.object(forKey: self.key) as? T }
//            .eraseToAnyPublisher()
        
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
            .prepend(wrappedValue)  // 补一个初始值，行为与之前一致
            .eraseToAnyPublisher()
    }
}

/*
 // 源码
 struct Foo {
 @UserDefault(key: "x", defaultValue: 0)
 var x: Int
 }
 
 // 编译器生成（等价代码）
 struct Foo {
 private var _x = UserDefault<Int>(key: "x", defaultValue: 0)
 var x: Int {
 get { _x.wrappedValue }
 set { _x.wrappedValue = newValue }
 }
 }
 */
