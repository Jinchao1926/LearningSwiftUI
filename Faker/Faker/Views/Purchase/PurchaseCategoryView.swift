//
//  PurchaseCategoryView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/27.
//

import SwiftUI

struct PurchaseCategoryView: View {
    @EnvironmentObject private var viewModel: PurchaseCategoryViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: GroupPurchaseHeader()) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        // modify acentColor: https://developer.apple.com/documentation/watchkit/setting_the_app_s_tint_color
                        if let category = category {
                            NavigationLink(destination: PurchaseView(category: category)) {
                                PurchaseCategoryRow(title: category.name)
                            }
                        }
                    }
                }
            }.onAppear(perform: {
                viewModel.fetchPurchaseList()
            }).listStyle(InsetListStyle())  // SidebarListStyle - 可收缩
        }//.frame(minWidth: 200, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)*/
        
    }
}
