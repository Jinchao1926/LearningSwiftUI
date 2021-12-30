//
//  GiftView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import SwiftUI

struct GiftListView: View {
    @EnvironmentObject private var viewModel: GiftViewModel
    
    var body: some View {
        List {
            if viewModel.gifts.count == 0 {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(x: 0.8, y: 0.8, anchor: .center)
                    Spacer()
                }
            }
            ForEach(viewModel.gifts.indices, id: \.self) { idx in
                GiftListRow(id: viewModel.gifts[idx]?.id, name: viewModel.gifts[idx]?.name, index: idx)
            }
        }.onAppear(perform: {
            viewModel.fetchGiftList()
        }).listStyle(InsetListStyle())  // SidebarListStyle - 可收缩
    }
}

