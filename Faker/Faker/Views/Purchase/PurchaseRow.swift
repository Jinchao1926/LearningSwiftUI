//
//  PurchaseRow.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import SwiftUI
import ToastUI

struct PurchaseRow: View {
    let fontSize: CGFloat = 14
    var phone: String?
    var password: String?
    var state: State = .idle
    var message: String?
    let index: Int?
    
    var title: String {
        String(format: "[%02d] %@ (%@)", (index ?? 0) + 1, phone ?? "", password ?? "")
    }
    
    @SwiftUI.State private var presentingToast: Bool = false
    
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
        }
        .frame(minHeight: 30)
        .onTapGesture(perform: {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(title, forType: .string)
            presentingToast = true
        })
        .toast(isPresented: $presentingToast, dismissAfter: 1) {
          ToastView("Copied!")
            .toastViewStyle(SuccessToastViewStyle())
        }
    }
}
