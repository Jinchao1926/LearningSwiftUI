//
//  PurchaseView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import SwiftUI

struct PurchaseView: View {
    var category: PurchaseCategoryModel {
        didSet {
//            viewModel.bulkReset()
        }
    }

    @EnvironmentObject private var viewModel: FakerViewModel
    @EnvironmentObject private var settings: SettingViewModel
    
    init(category: PurchaseCategoryModel) {
        self.category = category
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            // header
            PurchaseHeader(title: category.name ?? "Category") {
                viewModel.bulkPurchasing(with: category)
            }
            // list
            List {
                ForEach(viewModel.users.indices, id: \.self) { idx in
                    if let account = viewModel.users[idx] {
                        PurchaseRow(phone: account.phone,
                                    password: account.password,
                                    state: account.state,
                                    message: account.message,
                                    index: idx)
                    }
                }
            }
            .listStyle(InsetListStyle())
            .padding()
            
            // footer
            PurchaseFooter(interval: settings.intInterval, groupCount: settings.intGroupCount, groupInterval: settings.intGroupInterval)
        }.background(Color("GrayBackground"))
    }
}
