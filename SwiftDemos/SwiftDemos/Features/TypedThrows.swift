//
//  TypedThrows.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/25.
//

import Foundation

enum NetworkError: Error {
    case timeout
    case invalidURL
    case serverError(code: Int)
}

enum FileError: Error {
    case invalidID
    case invalidFile
}

// throws：声明函数可能抛出错误
func fetchData(from urlString: String) throws -> Data {
    guard let url = URL(string: urlString) else {
        throw NetworkError.invalidURL
    }
    // ...
    return Data()
}

func test1() {
    // do-catch 捕获
    do {
        let data = try fetchData(from: "https://api.example.com")
        print(data)
    } catch NetworkError.timeout {
        print("请求超时")
    } catch NetworkError.serverError(let code) {
        print("服务器错误: \(code)")
    } catch {
        print("未知错误: \(error)")
    }
}

// Swift 5 之前：只能声明 throws，具体类型丢失
func oldFetch() throws -> Data {
    throw FileError.invalidID
}

// Swift 6：typed throws，指定具体错误类型
func fetch() throws(NetworkError) -> Data {
    throw NetworkError.timeout  // 只能抛 NetworkError
//    throw FileError.invalidID
}

func test2() {
    // 调用方 catch 分支无需类型转换
    do {
        let data = try fetch()
    } catch {
        // error 的类型是 NetworkError（不是 any Error）
        switch error {
        case .timeout: print("超时")
        case .invalidURL: print("URL 错误")
        case .serverError(let code): print("服务器 \(code)")
        }
    }
}
