//
//  PurchaseView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import SwiftUI

struct PurchaseView: View {
    var category: PurchaseCategoryModel

    @EnvironmentObject private var viewModel: FakerViewModel
    
    init(category: PurchaseCategoryModel) {
        self.category = category
    }
    
    public var body: some View {
        VStack {
            PurchaseHeader(title: category.name ?? "Category") {
                viewModel.bulkPurchasing()
            }
            List {
                ForEach(viewModel.accounts.indices, id: \.self) { idx in
                    if let account = viewModel.accounts[idx] {
                        PurchaseRow(phone: account.phone,
                                    password: account.password,
                                    state: account.state,
                                    message: account.message,
                                    index: idx)
                    }
                }
            }.listStyle(InsetListStyle())
                .padding()
        }.background(Color(hex: "f9f9f9"))
    }
}
