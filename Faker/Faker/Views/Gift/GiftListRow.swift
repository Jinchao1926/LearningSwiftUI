//
//  GiftRow.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import SwiftUI
import ToastUI

struct GiftListRow: View {
    let fontSize: CGFloat = 14
    var id: Int?
    var name: String?
    let index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%d)", index ?? 0, name ?? "", id ?? 0)
    }
    
    @SwiftUI.State private var presentingToast: Bool = false
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize))
            .foregroundColor(Color(.black))
            .fixedSize(horizontal: true, vertical: false)
            .onTapGesture {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(String(format: "%d-%@", id ?? 0, name ?? ""), forType: .string)
                presentingToast = true
            }
            .toast(isPresented: $presentingToast, dismissAfter: 1) {
              ToastView("Copied!")
                .toastViewStyle(SuccessToastViewStyle())
            }
    }
}

