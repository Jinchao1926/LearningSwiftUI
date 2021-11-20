//
//  ChessButton.swift
//  Chess
//
//  Created by 林锦超 on 2021/11/20.
//

import SwiftUI

///
struct ChessButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize = CGSize(width: 80, height: 80)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.black)
                .frame(width: size.width, height: size.height)
                .background(Color(.white))
        }
    }
}

//struct ChessButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ChessButton(title: "x") {
//
//        }
//    }
//}

///
struct ChessRow: View {
    @EnvironmentObject private var model: ChessModel
    
    let row: [ChessItem]
    let rowIndex: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(row.indices, id: \.self) { (idx) in
                ChessButton(title: row[idx].rawValue) {
                    model.playing(atRow: rowIndex, col: idx)
                }.disabled(row[idx] != .empty)
            }
        }
    }
}

///
struct ChessPad: View {
    let pad: [[ChessItem]]
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ForEach(pad.indices, id: \.self) { (idx) in
                ChessRow(row: pad[idx], rowIndex: idx)
            }
        }.background(Color(.gray))
    }
}





