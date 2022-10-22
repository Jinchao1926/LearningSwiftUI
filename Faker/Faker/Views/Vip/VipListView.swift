//
//  VipListView.swift
//  Faker
//
//  Created by Jinchao.Lin on 2022/10/22.
//

import SwiftUI

struct VipListView: View {
    @EnvironmentObject private var viewModel: FakerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Button {
                    viewModel.bulkVips()
                } label: {
                    Text("查看会员卡信息")
                        .modifier(ConfirmTextModifier())
                }
                .buttonStyle(PlainButtonStyle())
                .padding([.leading, .top, .trailing], 10)

                Text("Tips: 过期会员高亮显示")
                    .foregroundColor(Color(.gray))
            }


            NavigationView {
                // list
                List {
                    ForEach(viewModel.users.indices, id: \.self) { idx in
                        if let account = viewModel.users[idx] {
                            VipListRow(phone: account.phone,
                                       password: account.password,
                                       cardName: account.vip?.cardTitle,
                                       bonus: account.vip?.bonus,
                                       expire: account.vip?.expire,
                                       index: idx)
                        }
                    }
                }
                .listStyle(InsetListStyle())
                .frame(minWidth: 600, idealWidth: 600, maxWidth: 600, minHeight: 500, idealHeight: 500, maxHeight: .infinity)
            }
            .background(Color("GrayBackground"))
            .padding(5)
        }
    }
}

struct VipListRow: View {
    var phone: String?
    var password: String?
    var cardName: String?
    var bonus: Float?
    var expire: VipExpirationModel?
    let index: Int?

    var expireTime: String? { expire?.expiryTime }
    var isExpired: Bool {
        guard let expireDate = expire?.ExpiryTime else { return false }
        return expireDate < Date()
    }

    var title: String {
        String(
            format: "[%02d] %@ (%@): 会员(%@) 积分(%.0f) 过期时间(%@)",
            (index ?? 0) + 1,
            phone ?? "",
            password ?? "",
            cardName ?? "?",
            bonus ?? 0,
            expireTime ?? "?"
        )
    }

    var body: some View {
        Text(title)
            .font(.system(size: 14))
            .foregroundColor(Color(.black))
            .fixedSize(horizontal: true, vertical: false)
            .background(Color(isExpired ? .yellow : .white))
    }
}
