//
//  AccountView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/29.
//

import SwiftUI
import ToastUI

struct AccountView: View {
    private var viewModel: AccountViewModel = AccountViewModel.shared
    private var disableStringSelection = false
    
    @SwiftUI.State var data: String = ""
    @SwiftUI.State private var presentingToast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AccountTipsView()
                Spacer()
                Button {
                    if data.count > 0 {
                        if self.viewModel.exportToPlist(with: data) {
                            presentingToast = true
                        }
                    }
                } label: {
                    Text("确 定")
                        .modifier(ConfirmTextModifier())
                }
                .buttonStyle(PlainButtonStyle())
                .toast(isPresented: $presentingToast, dismissAfter: 1) {
                  ToastView("Success")
                    .toastViewStyle(SuccessToastViewStyle())
                }
            }
            AccountPathView()
            TextEditor(text: $data)
                .font(.system(size: 14))
                .textSelection(.enabled)
                .accentColor(Color("BlueBackground"))
        }
        .frame(minWidth: 400, idealWidth: 500, maxWidth: 500, minHeight: 200, idealHeight: 300, maxHeight: .infinity, alignment: .center)
        .padding()
        .onAppear {
            data = viewModel.readPlistUserStrings()
        }
    }
}

struct AccountTipsView: View {
    let tips = """
账号导入格式 [手机号 密码] eg:
18688888888 123456
18699999999 123456
"""
    var body: some View {
        Text(tips)
            .textSelection(.enabled)
    }
}

struct AccountPathView: View {
    @SwiftUI.State private var presentingToast: Bool = false
    
    var body: some View {
        Text("导出路径 (点击可复制):\n \(AccountViewModel.shared.path)")
            .font(.footnote)
            .onTapGesture {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(AccountViewModel.shared.path, forType: .string)
                presentingToast = true
            }
            .toast(isPresented: $presentingToast, dismissAfter: 1) {
              ToastView("Copied!")
                .toastViewStyle(SuccessToastViewStyle())
            }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
