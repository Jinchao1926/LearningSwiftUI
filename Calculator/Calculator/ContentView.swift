//
//  ContentView.swift
//  Calculator
//
//  Created by 林锦超 on 2021/8/13.
//

import SwiftUI

struct ContentView: View {
    /// @State 可以依靠 SwiftUI 框架完成 View 的自动订阅和刷新, 
    /// 如果你需要在多个 View 中共享数据，@State 可能不是很好的选择
//    @State private var brain: CalculatorBrain = .left("0")
    
//    @ObservedObject private var model: CalculatorModel = CalculatorModel()
    
    @EnvironmentObject private var model: CalculatorModel
    @State private var editingHistory: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Spacer()
//            Button("操作记录: \(model.history.count)") {
//                print(model.history)
//                editingHistory = true
//            }.sheet(isPresented: $editingHistory) {
//                HistoryView(model: model)
//            }
            Text(model.output)
                .font(.system(size: 76))
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
            CalculatorButtonPad()
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
