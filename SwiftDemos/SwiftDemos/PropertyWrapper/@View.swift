//
//  LoginView.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/27.
//

import SwiftUI

// MARK: - ObservableObject + @StateObject + @Published
struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Text(String("Is Logined：\(viewModel.isLogined)"))
            
            if viewModel.isLogined {
                if let user = viewModel.user {
                    Text(String("User：\(user)"))
                }
            } else {
                Button("Login") {
                    viewModel.login()
                }
            }
        }
    }
}

// MARK: - @State + @Binding
/// `@Binding` 不持有数据，是**指向外部状态的读写代理**（类似 `inout` 参数的持久化版本）
struct ParentToggleView: View {
    @State private var isOn = false

    var body: some View {
        ToggleView(isOn: $isOn)  // $isOn → Binding<Bool>
        Text(isOn ? "ON" : "OFF")
    }
}

struct ToggleView: View {
    @Binding var isOn: Bool  // 不持有，修改写回父 View

    var body: some View {
        Toggle("Enable", isOn: $isOn)
    }
}

// MARK: - @ObservedObject + @EnvironmentObject
struct AppView: View {
    @StateObject private var store = AppStore()

    var body: some View {
        ChildView(store: store)
    }
}

struct ChildView: View {
    @ObservedObject var store: AppStore
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack {
            Text(String("Version: \(store.version)"))
            Text(String("Theme: \(state.theme)"))
        }
    }
}

#Preview {
    VStack {
        LoginView()
        ParentToggleView()
        Divider()
        AppView()
    }
    .environmentObject(AppState())
}
