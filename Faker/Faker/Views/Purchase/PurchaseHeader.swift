//
//  PurchaseHeader.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import SwiftUI

struct PurchaseHeader: View {
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

struct PurchaseFooter: View {
    var interval: UInt32
    var groupCount: Int
    var groupInterval: UInt32
    
    var title: String {
        String(format: "Tips: [%d个]账号一组，组间间隔[%d分钟]，组内间隔[%d秒]", groupCount, groupInterval, interval)
    }
    
    var body: some View {
        Text(title)
            .font(.footnote)
            .lineLimit(1)
            .padding([.leading, .bottom, .trailing])
    }
}
