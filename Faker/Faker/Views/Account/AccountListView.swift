//
//  AccountListView.swift
//  Faker
//
//  Created by 林锦超 on 2022/1/2.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject private var viewModel: FakerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                viewModel.bulkCoupons()
            } label: {
                Text("查看券包数量")
                    .modifier(ConfirmTextModifier())
            }
            .buttonStyle(PlainButtonStyle())
            .padding([.leading, .top, .trailing], 10)
            
            NavigationView {
                // list
                List {
                    ForEach(viewModel.users.indices, id: \.self) { idx in
                        if let account = viewModel.users[idx] {
                            if let token = account.token {
                                NavigationLink(destination: CouponListView(token: token)) {
                                    AccountListRow(phone: account.phone,
                                                   password: account.password,
                                                   couponCount: account.couponCount,
                                                   index: idx)
                                }
                            }
                            else {
                                AccountListRow(phone: account.phone,
                                               password: account.password,
                                               couponCount: account.couponCount,
                                               index: idx)
                            }
                        }
                    }
                }
                .listStyle(InsetListStyle())
                .frame(minWidth: 400, idealWidth: 450, maxWidth: 500, minHeight: 500, idealHeight: 500, maxHeight: .infinity)
            }
            .background(Color("GrayBackground"))
            .padding(5)
        }
    }
}

struct AccountListRow: View {
    var phone: String?
    var password: String?
    var couponCount: Int?
    let index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%@) (%d)张券可用", (index ?? 0) + 1, phone ?? "", password ?? "", couponCount ?? 0)
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: 14))
            .foregroundColor(Color(.black))
            .fixedSize(horizontal: true, vertical: false)
    }
}
