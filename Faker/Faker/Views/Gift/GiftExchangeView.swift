//
//  GiftExchangeView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import SwiftUI

struct GiftExchangeView: View {
    @EnvironmentObject private var viewModel: GiftExchangeViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.datas, id: \.self) { data in
                Section(data.user) {
                    ForEach(data.gifts.indices, id: \.self) { idx in
                        GiftExchangeRow(id: data.gifts[idx].id,
                                        name: data.gifts[idx].name,
                                        state: data.gifts[idx].state,
                                        message: data.gifts[idx].message,
                                        index: idx)
                    }
                }
            }
        }.listStyle(InsetListStyle())
    }
}

