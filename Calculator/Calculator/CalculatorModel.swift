//
//  CalculatorModel.swift
//  Calculator
//
//  Created by 林锦超 on 2021/8/16.
//

import SwiftUI

class CalculatorModel: ObservableObject {
    @Published private var brain: CalculatorBrain = .left("0")
    
    @Published var history: [CalculatorButtonItem] = []
    
    //
    var output: String { brain.output }
    
    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        
        temporary.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    //
    var historyDetail: String {
        history.map({ $0.description }).joined()
    }
    
    var temporary: [CalculatorButtonItem] = []
    
    var totalCount: Int { history.count + temporary.count }
    
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporary
        history = Array(total[..<index])
        temporary = Array(total[index...])
        brain = history.reduce(CalculatorBrain.left("0")) { result, item in
            result.apply(item: item)
        }
    }
}
