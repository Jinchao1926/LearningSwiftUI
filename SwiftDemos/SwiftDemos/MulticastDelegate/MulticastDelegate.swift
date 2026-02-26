//
//  MulticastDelegate.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/24.
//

import Foundation

class MulticastDelegate<T> {
    private let lock = NSLock()
    
    // 弱引用容器，容器不会增加对象的引用计数
    // 对象销毁后自动置空并清理，无内存泄漏风险
    // 不允许重复元素（重复添加会被去重）
    // 高（O (1)），通过哈希值快速定位
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    
    func addDelegate(_ delegate: T) {
        lock.lock()
        defer { lock.unlock() }
        guard let delegate = delegate as AnyObject? else { return }
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: T) {
        lock.lock()
        defer { lock.unlock() }
        guard let delegate = delegate as AnyObject? else { return }
        delegates.remove(delegate)
    }
    
    func removeAllDelegates() {
        lock.lock()
        defer { lock.unlock() }
        delegates.removeAllObjects()
    }
    
    func invoke(_ closure: (T) -> Void) {
        lock.lock()
        let allDelegates = delegates.allObjects
        lock.unlock()
        
        for delegate in allDelegates {
            guard let delegate = delegate as? T else { continue }
            closure(delegate)
        }
    }
}
