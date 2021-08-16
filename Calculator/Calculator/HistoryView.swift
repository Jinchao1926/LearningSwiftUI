//
//  HistoryView.swift
//  Calculator
//
//  Created by 林锦超 on 2021/8/16.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有记录")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.output)")
                }
                
                Slider(
                    value: $model.slidingIndex,
                    in: 0...Float(model.totalCount),
                    step: Float(1)
                ).padding()
            }
        }
    }
}
