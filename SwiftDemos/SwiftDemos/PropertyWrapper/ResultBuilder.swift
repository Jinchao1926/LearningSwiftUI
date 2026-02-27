//
//  ResultBuilder.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/26.
//

import Foundation

/**
@resultBuilder 是 Swift 5.4 引入的特性，允许你用声明式 DSL
语法来构建值。它的核心思想是：把一系列表达式"累积"成一个结果，由编译器在幕后完成组装。
 
SwiftUI 的 @ViewBuilder 就是典型应用。
 
工作原理
编译器会把 @ArrayBuilder 闭包中的语句，自动转换成对 builder 静态方法的调用：

┌────────────────────────────────────────────┬─────────────────────────┐
│                  静态方法                  │          作用           │
├────────────────────────────────────────────┼─────────────────────────┤
│ buildExpression(_:)                        │ 把单个元素 T 包装成 [T] │
├────────────────────────────────────────────┼─────────────────────────┤
│ buildBlock(_:...)                          │ 把所有分量 flatMap 合并 │
├────────────────────────────────────────────┼─────────────────────────┤
│ buildOptional(_:)                          │ 处理 if（无 else）分支  │
├────────────────────────────────────────────┼─────────────────────────┤
│ buildEither(first:) / buildEither(second:) │ 处理 if-else 两个分支   │
└────────────────────────────────────────────┴─────────────────────────┘
*/

@resultBuilder
struct ArrayBuilder<T> {
    // 必须实现：合并多个分量
    static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }

    // 可选：支持单个元素
    static func buildExpression(_ expression: T) -> [T] {
        [expression]
    }

    // 可选：支持 if 分支
    static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }

    // 可选：支持 if-else
    static func buildEither(first component: [T]) -> [T] { component }
    static func buildEither(second component: [T]) -> [T] { component }
}

struct ArrayBuilderTester {
    func makeArray<T>(@ArrayBuilder<T> _ content: () -> [T]) -> [T] {
         content()
     }
    
    @ArrayBuilder<Int>
    func buildNumbers() -> [Int] {
        1
        2
        3
    }
    
    func build(showBonus: Bool) -> [Int] {
        let score = 90

        /**
         编译器实际展开的逻辑（伪代码）
         let e1 = ArrayBuilder.buildExpression(1)   // [1]
         let e2 = ArrayBuilder.buildExpression(2)   // [2]
         let e3 = ArrayBuilder.buildExpression(3)   // [3]

         // if showBonus { 99 } → buildOptional
         let e4 = showBonus
             ? ArrayBuilder.buildOptional(ArrayBuilder.buildExpression(99))  // [99]
             : ArrayBuilder.buildOptional(nil)                               // []

         // if score >= 60 { 100 } else { 0 } → buildEither
         let e5 = score >= 60
             ? ArrayBuilder.buildEither(first: ArrayBuilder.buildExpression(100))   // [100]
             : ArrayBuilder.buildEither(second: ArrayBuilder.buildExpression(0))    // [0]

         // buildBlock 把所有分量合并
         return ArrayBuilder.buildBlock(e1, e2, e3, e4, e5)
         // flatMap → [1, 2, 3, 99, 100]
         */
        let result = makeArray {
            // buildExpression 把每个 Int 包装成 [Int]
            1
            2
            3

            // buildOptional：if 无 else，可能为 nil
            if showBonus {
              99
            }

            // buildEither：if-else，两路都有值
            if score >= 60 {
              100
            } else {
              0
            }
        }
        return result
    }
}
