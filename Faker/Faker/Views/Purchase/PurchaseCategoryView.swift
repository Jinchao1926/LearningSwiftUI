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
                if viewModel.categories.count == 0 {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(x: 0.8, y: 0.8, anchor: .center)
                        Spacer()
                    }
                }
                ForEach(viewModel.categories, id: \.self) { category in
                    // modify acentColor: https://developer.apple.com/documentation/watchkit/setting_the_app_s_tint_color
                    if let category = category {
                        NavigationLink(destination: PurchaseView(category: category)) {
                            PurchaseCategoryRow(title: category.name)
                        }
                    }
                }
            }.onAppear(perform: {
                viewModel.fetchPurchaseList()
            }).listStyle(InsetListStyle())  // SidebarListStyle - 可收缩
        }
    }
}
