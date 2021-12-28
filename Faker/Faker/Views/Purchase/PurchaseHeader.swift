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

struct PurchaseHeader_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseHeader(title: "Category") {
            
        }
    }
}
