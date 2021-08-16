//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by 林锦超 on 2021/8/13.
//

import SwiftUI

enum CalculatorButtonItem {
    
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem {
    var title: String {
        switch self {
        case .digit(let value): return String(value);
        case .dot:              return "."
        case .op(let op):       return op.rawValue
        case .command(let cmd): return cmd.rawValue
        }
    }
    
    var size: CGSize {
        var width = 80
        if self == .digit(0) {
            width = 160
        }
        return CGSize(width: width, height: 80)
    }
    
    var backgroundColorName: String {
        switch self {
        case .digit, .dot:  return "digitBackground"
        case .op:           return "operatorBackground"
        case .command:      return "commandBackground"
        }
    }
}

extension CalculatorButtonItem: Hashable {}

extension CalculatorButtonItem: CustomStringConvertible {
    var description: String { title }
}
