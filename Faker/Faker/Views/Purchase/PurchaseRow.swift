//
//  PurchaseRow.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import SwiftUI

struct PurchaseRow: View {
    let fontSize: CGFloat = 14
    var phone: String?
    var password: String?
    var state: State = .idle
    var message: String?
    let index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%@)", index ?? 0, phone ?? "", password ?? "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(Color(.black))
                .fixedSize(horizontal: true, vertical: false)
            
            if let message = message {
                Text(message)
                    .foregroundColor(Color(.black))
            }
        }
    }
}

//struct PurchaseRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PurchaseRow()
//    }
//}
