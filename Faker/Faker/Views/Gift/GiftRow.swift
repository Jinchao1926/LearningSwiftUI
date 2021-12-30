//
//  GiftRow.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import SwiftUI

struct GiftRow: View {
    let fontSize: CGFloat = 14
    var id: Int?
    var name: String?
    let index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%@)", index ?? 0, name ?? "")
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize))
            .foregroundColor(Color(.black))
            .fixedSize(horizontal: true, vertical: false)
    }
}

