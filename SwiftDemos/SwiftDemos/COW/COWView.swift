//
//  COWView.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/23.
//

import SwiftUI

struct COWView: View {
    var body: some View {
        VStack {
            Button("Copy-on-Write") {
                testCopyOnWrite()
            }
            .padding()
            
            Button("Copy-on-Write MyArray") {
                testCopyOnWriteMyArray()
            }
            .padding()
        }
        .navigationTitle("COW")
    }
    
    private func testCopyOnWrite() {
        var array1 = [1, 2, 3]
        var array2 = array1  // 此时共享同一块内存

        // 获取底层存储地址
        withUnsafePointer(to: &array1) { debugPrint($0) }  // 地址 A
        withUnsafePointer(to: &array2) { debugPrint($0) }  // 地址 B（变量地址不同）

        // 但底层 buffer 是共享的
        array1.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 X
        array2.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 X（buffer 地址相同）

        array2.append(4)  // 触发 COW，复制 buffer

        array1.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 X
        array2.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 Y（buffer 地址已不同）
    }
    
    private func testCopyOnWriteMyArray() {
        var array1 = MyArray([1, 2, 3])
        var array2 = array1  // 此时共享同一块内存

        // 获取底层存储地址
        withUnsafePointer(to: &array1) { debugPrint($0) }  // 地址 A
        withUnsafePointer(to: &array2) { debugPrint($0) }  // 地址 B（变量地址不同）

        // 但底层 buffer 是共享的
        array1.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 X
        array2.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 X（buffer 地址相同）

        array2[2] = 4  // 触发 COW，复制 buffer

        array1.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 X
        array2.withUnsafeBufferPointer { debugPrint($0.baseAddress as Any) }  // 地址 Y（buffer 地址已不同）
    }
}

#Preview {
    COWView()
}
