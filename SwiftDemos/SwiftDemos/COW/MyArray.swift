//
//  MyArray.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/23.
//

import Foundation

struct MyArray<Element> {
    private var storage: ArrayStorage<Element>  // class reference

    var count: Int { storage.count }
    
    init(_ elements: [Element]) {
        self.storage = ArrayStorage(buffer: elements)
    }

    subscript(index: Int) -> Element {
        get {
            // 读取时共享
            return storage.buffer[index]
        }
        set {
            if !isKnownUniquelyReferenced(&storage) {
                // 写时复制：如果有多个引用，先复制
                storage = storage.copy()
            }
            storage.buffer[index] = newValue
        }
    }
    
    func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        return try storage.buffer.withUnsafeBufferPointer(body)
    }
}

extension MyArray: Sequence {
    func makeIterator() -> Array<Element>.Iterator {
        return storage.buffer.makeIterator()
    }
}

class ArrayStorage<Element> {
    var buffer: [Element]
    var count: Int
    
    init(buffer: [Element]) {
        self.buffer = buffer
        self.count = buffer.count
    }

    func copy() -> ArrayStorage<Element> {
        print("⚠️ 触发 COW 拷贝") // 拷贝时打印日志
        return ArrayStorage(buffer: buffer)
    }
}
