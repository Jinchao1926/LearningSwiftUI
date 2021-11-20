//
//  ChessItem.swift
//  Chess
//
//  Created by 林锦超 on 2021/11/20.
//

import SwiftUI

enum ChessItem: String {
    case empty = ""
    case x = "X"
    case o = "O"
}

extension ChessItem {
    var title: String { rawValue }
    
    var intValue: Int {
        Int(UnicodeScalar(rawValue)?.value ?? 0)
    }
}

extension ChessItem: Hashable {}

extension ChessItem: CustomStringConvertible {
    var description: String { title }
}
