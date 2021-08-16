//
//  CalculatorButtonRow.swift
//  Calculator
//
//  Created by 林锦超 on 2021/8/13.
//

import SwiftUI

struct CalculatorButtonRow: View {
//    @Binding var brain: CalculatorBrain
    @EnvironmentObject var model: CalculatorModel
    
    let row: [CalculatorButtonItem]
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { (item) in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName, action: {
                    print("button \(item.title)")
                    model.apply(item)
//                    brain = brain.apply(item: item)
                })
            }
            
            /*
            row.forEach { (item) in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName, action: {
                    print("button \(item.title)");
                })
            } */
        }

    }
}
