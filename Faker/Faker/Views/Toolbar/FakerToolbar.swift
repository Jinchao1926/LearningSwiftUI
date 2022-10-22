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
                NavigationLink(destination: AccountListView()) {
                    Label("券包", systemImage: "folder.circle")
                }
                NavigationLink(destination: VipListView()) {
                    Label("会员", systemImage: "v.circle")
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
                Divider()
                NavigationLink(destination: GiftView()) {
                    Label("兑换", systemImage: "purchased")
                }
                .disabled(true)
            }.listStyle(SidebarListStyle())  // SidebarListStyle - 可收缩
        }//.frame(minWidth: 200, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
}

