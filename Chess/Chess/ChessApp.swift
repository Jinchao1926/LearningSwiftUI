//
//  ChessApp.swift
//  Chess
//
//  Created by 林锦超 on 2021/11/20.
//

import SwiftUI

@main
struct ChessApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ChessModel())
        }
    }
}
