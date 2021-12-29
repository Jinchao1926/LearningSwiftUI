//
//  FakerToolbar.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/29.
//

import SwiftUI

struct FakerToolbar: View {
    @EnvironmentObject var viewModel: FakerViewModel
    
    var body: some View {
        NavigationView {
            List {
                Spacer()
                NavigationLink(destination: PurchaseCategoryView()) {
                    Label("团购", systemImage: "purchased.circle")
                }
                Divider()
                Group {
                    NavigationLink(destination: AccountView()) {
                        Label("账号", systemImage: "person")
                    }
                    NavigationLink(destination: SettingView()) {
                        Label("设置", systemImage: "gear")
                    }
                }
            }.listStyle(SidebarListStyle())  // SidebarListStyle - 可收缩
        }//.frame(minWidth: 200, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .disabled(viewModel.isPurchasing)
    }
}

