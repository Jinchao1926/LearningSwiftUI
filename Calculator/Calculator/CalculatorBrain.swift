//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 林锦超 on 2021/8/16.
//

import SwiftUI

enum CalculatorBrain {
    case left(String)
    case leftOp(left: String, op: CalculatorButtonItem.Op)
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
    case equal(String)
    case error

    /// output
    var output: String {
        let result: String

        switch self {
        case .left(let left):   result = left
        case .leftOp(let left, _):  result = left
        case .leftOpRight(_, _, let right): result = right
        case .equal(let equal): result = equal
        case .error:    return "Error"
        }

        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: value as NSNumber)!
    }
    
    /// apply
    /// 状态事件循环
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case .digit(let num):       return apply(num: num)
        case .dot:                  return applyDot()
        case .op(let op):           return apply(op: op)
        case .command(let command): return apply(command: command)
        }
    }
    
    private func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .equal, .error:
            return .left("0".apply(num: num))
        }
    }
    
    private func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .equal, .error:
            return .left("0".applyDot())
        }
    }
    
    private func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .left(let left):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case .leftOp(let left, let currentOp):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)  // replace op
            case .equal:
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                }
                return .error
            }
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                }
                return .error
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .equal(result)
                }
                return .error
            }
        case .equal, .error:
            return self
        }
    }
    
    private func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(let left, let op):
                return .leftOp(left: left.flipped(), op: op)
            case .leftOpRight(let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .equal, .error:
                return .left("0")
            }
        case .percent:
            switch self {
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .equal, .error:
                return .left(output.percentaged())
            }
        }
    }
}

var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

extension String {
    var containsDot: Bool { contains(".") }
    
    var isNegative: Bool { starts(with: "-") }
    
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }
    
    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }
    
    func flipped() -> String {
        if isNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension CalculatorButtonItem.Op {
    func calculate(l: String, r: String) -> String? {
        guard let left = Double(l), let right = Double(r) else {
            return nil
        }
        
        let result: Double?
        
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .multiply: result = left * right
        case .divide: result = (right == 0) ? nil : left / right
        case .equal: fatalError()
        }
        
        return result.map { String($0) }
    }
}
