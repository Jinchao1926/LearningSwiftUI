//
//  CouponListView.swift
//  Faker
//
//  Created by 林锦超 on 2022/1/2.
//

import SwiftUI

struct CouponListView: View {
    @EnvironmentObject private var viewModel: CouponViewModel
    var token: String
    
    var body: some View {
        // list
        List {
            if viewModel.coupons.count == 0 {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(x: 0.8, y: 0.8, anchor: .center)
                    Spacer()
                }
            }
            ForEach(viewModel.coupons.indices, id: \.self) { idx in
                CouponListRow(id: viewModel.coupons[idx]?.ruleNo,
                              name: viewModel.coupons[idx]?.name,
                              index: idx)
            }
        }.onAppear(perform: {
            viewModel.fetchCouponList(token: token)
        }).listStyle(InsetListStyle())  // SidebarListStyle - 可收缩
    }
}
