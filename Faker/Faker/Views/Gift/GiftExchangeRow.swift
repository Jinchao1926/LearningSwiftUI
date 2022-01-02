//
//  GiftExchangeRow.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import SwiftUI

struct GiftExchangeRow: View {
    let fontSize: CGFloat = 14
    var id: Int?
    var name: String?
    var state: State = .idle
    var message: String?
    var index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%d)", (index ?? 0) + 1, name ?? "", id ?? "0")
    }
    
    var body: some View {
        HStack {
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
            Spacer()
            // State
            if state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(x: 0.6, y: 0.6, anchor: .center)
            }
            else if state == .success {
                Image(systemName: "checkmark.circle.fill")
                    .scaleEffect(x: 1.2, y: 1.2, anchor: .center)
                    .padding(.trailing, 10)
            }
            else if state == .failure {
                Image(systemName: "exclamationmark.circle.fill")
                    .scaleEffect(x: 1.2, y: 1.2, anchor: .center)
                    .padding(.trailing, 10)
            }
        }.frame(minHeight: 30)
    }
}

