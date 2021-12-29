//
//  SettingView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/29.
//

import SwiftUI
import ToastUI

struct SettingView: View {
    var body: some View {
        SettingContentView()
            .frame(minWidth: 400, idealWidth: 400, maxWidth: 400, minHeight: 200, idealHeight: 300, maxHeight: .infinity, alignment: .center)
            .padding()
    }
}

private struct SettingContentView: View {
    @EnvironmentObject private var viewModel: SettingViewModel
    @SwiftUI.State private var presentingToast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("通用设置")
                .font(.system(size: 20))
            //
            HStack {
                Text("设置每个账号的抢购时间间隔为")
                TextField("", text: $viewModel.interval)
                    .modifier(SettingTextFieldModifier())
                Text("秒")
                Spacer()
            }.lineLimit(1)
            //
            HStack {
                Text("设置每抢购")
                TextField("", text: $viewModel.groupCount)
                    .modifier(SettingTextFieldModifier())
                Text("个账号后，等待")
                TextField("", text: $viewModel.groupInterval)
                    .modifier(SettingTextFieldModifier())
                Text("分钟，方便支付")
                Spacer()
            }.lineLimit(1)
            Spacer()
            //
            HStack {
                Spacer()
                Button {
                    presentingToast = viewModel.synchronize()
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
        }
    }
}

// ViewModifier 可以跨越页面作用在任意 View 上
struct SettingTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 50)
    }
}

struct ConfirmTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .foregroundColor(.white)
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 15)
            .background(Color("BlueBackground"))
            .cornerRadius(8)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
