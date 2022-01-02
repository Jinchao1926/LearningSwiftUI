//
//  CouponListRow.swift
//  Faker
//
//  Created by 林锦超 on 2022/1/2.
//

import SwiftUI

struct CouponListRow: View {
    let fontSize: CGFloat = 14
    var id: String?
    var name: String?
    let index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%d)", (index ?? 0) + 1, name ?? "", id ?? "")
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize))
            .foregroundColor(Color(.black))
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct CouponHeader: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Color(.black))
                .fixedSize(horizontal: true, vertical: false)
            Spacer()
            Image(systemName: "play.fill")
                .scaleEffect(x: 1.4, y: 1.4, anchor: .center)
                .padding(.trailing, 10)
                .onTapGesture {
                    action()
                }
        }.padding([.leading, .top, .trailing])
    }
}
