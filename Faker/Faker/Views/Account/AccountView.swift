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
        .frame(minWidth: 400, idealWidth: 600, maxWidth: 600, minHeight: 300, idealHeight: 300, maxHeight: .infinity, alignment: .center)
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
    let importantTips = """
@@ 【团购】【券包】等登录成功会缓存 token 到本地
@@ 点击右侧【确定】按钮重新导入账号可以清除本地 token
"""
    var body: some View {
        VStack(alignment: .leading) {
            Text(importantTips)
                .foregroundColor(.red)
                .padding(.bottom, 5)
            Text(tips)
                .textSelection(.enabled)
        }
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
