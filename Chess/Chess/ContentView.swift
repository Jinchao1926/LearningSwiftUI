//
//  ContentView.swift
//  Chess
//
//  Created by 林锦超 on 2021/11/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: ChessModel
    
    var body: some View {
        VStack(alignment:.leading) {
            Spacer()
            Button {
                model.restart()
            } label: {
                Text("Restart")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }.padding()
            
            VStack(alignment:.leading) {
                Text("Current Step: \(model.currentSetp.rawValue)")
                    .font(.system(size: 24))
                
                if let winner = model.winner {
                    Text("Winner: \(winner.rawValue)")
                        .font(.system(size: 24))
                }
            }.padding()
            Spacer()
            ChessPad(pad: model.board)
                .padding(.bottom, 150)
                .disabled(model.winner != nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
