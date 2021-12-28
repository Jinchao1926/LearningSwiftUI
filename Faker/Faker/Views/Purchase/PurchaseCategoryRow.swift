//
//  PurchaseCategoryRow.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/27.
//

import SwiftUI

struct PurchaseCategoryRow: View {
    let fontSize: CGFloat = 16
    let title: String?
    
    var body: some View {
        Text(title ?? "")
            .font(.system(size: fontSize))
            .foregroundColor(Color(.black))
            .padding([.top, .bottom], 5)
            .fixedSize(horizontal: true, vertical: false)
    }
}


struct GroupPurchaseHeader: View {
    let fontSize: CGFloat = 20
    var body: some View {
        Text("团购")
            .font(.system(size: fontSize))
            .padding()
    }
}
