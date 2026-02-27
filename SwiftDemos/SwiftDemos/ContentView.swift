//
//  ContentView.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/23.
//

import SwiftUI

struct ContentView: View {
    private var demos = ["COW", "PropertyWrapper", "Async", "Sendable"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(demos.enumerated(), id: \.element) { idx, item in
                    if idx == 0 {
                        NavigationLink(item, destination: COWView())
                    } else if idx == 1 {
                        NavigationLink(item, destination: PropertyWrapperView())
                    } else if idx == 2 {
                        NavigationLink(item, destination: AsyncView())
                    } else if idx == 3 {
                        NavigationLink(item, destination: SendableView())
                    }
                }
            }
            .navigationTitle("SwiftDemo")
        }
    }
}

#Preview {
    ContentView()
}
