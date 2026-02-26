//
//  SomeAny.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/24.
//

import Foundation

protocol Animal {
    associatedtype Food
    func eat(_ food: Food)
    @discardableResult func sound() -> String
}

struct Dog: Animal {
    func eat(_ food: String) { print("Dog eats \(food)") }
    func sound() -> String { "Woof" }
}

struct Cat: Animal {
    func eat(_ food: String) { print("Cat eats \(food)") }
    func sound() -> String { "Meow" }
}

// MARK: - some — Opaque Type（不透明类型）
// 编译期确定单一具体类型，编译器全程知晓真实类型，可进行静态派发。
// ✅ 调用者不知道是 Dog 还是 Cat，但编译器知道，类型信息被"隐藏"
func makeAnimal() -> some Animal {
    Dog() // 整个函数只能返回同一种类型
}

// ✅ SwiftUI 大量使用：body 返回的是固定结构，编译器优化派发
//var body: some View {
//    VStack { Text("Hello") }
//}

// ❌ 编译报错：不同分支返回不同类型
//func makeAnimal(isdog: Bool) -> some Animal {
//    if isdog { return Dog() }
//    else { return Cat() } // error: have different underlying types
//}


// MARK: - any — Existential Type（存在类型）

// 运行时持有任意符合协议的类型，内部是一个 existential container
//（通常 40 字节：value buffer 3 words + metadata pointer + witness table pointer）。

// ✅ 运行时多态，可以在容器中混装不同类型
func makeAnyAnimal(isDog: Bool) -> any Animal {
    if isDog { return Dog() }
    else { return Cat() }
}

// ✅ 异构集合必须用 any
let animals: [any Animal] = [Dog(), Cat(), Dog()]
func test() {
    for animal in animals {
        print(animal.sound()) // 动态派发，通过 witness table
    }
}

// ❌ 存在类型不能直接参与泛型约束比较（type identity 丢失）
func isSame(_ a: any Animal, _ b: any Animal) -> Bool {
    // a == b  // error：Animal 没有 Equatable 约束
    return false
}



// 性能敏感场景对比
// some：编译器可内联，零运行时开销
func processOpaque(_ animal: some Animal) {
    animal.sound() // 静态派发，可被编译器内联
}

// any：每次调用走 witness table 查找
func processExistential(_ animal: any Animal) {
    animal.sound() // 动态派发，+ 可能的堆分配（值类型 > 3 words 时）
}

// Swift 5.7+ 用 any 打开存在类型
func openAndProcess(_ animal: any Animal) {
    // open existential：临时获得具体类型信息
    func helper<T: Animal>(_ a: T) { a.sound() }
    helper(animal) // 编译器自动 open
}

// 一句话记忆：some 是"我知道是谁但不告诉你"（编译期确定），any 是"运行时才知道是谁"（存在容器）。性能敏感路径优先
// some，需要异构/运行时多态用 any。
