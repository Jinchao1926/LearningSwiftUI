//
//  PropertyWrapperView.swift
//  SwiftDemos
//
//  Created by Jinchao Lin on 2026/2/26.
//

import SwiftUI

struct PropertyWrapperView: View {
    @UserDefault(key: "isDarkMode", defaultValue: false)
    var isDarkMode: Bool    // _isDarkMode.wrappedValue
    
    let tester = ArrayBuilderTester()
    
    var body: some View {
        VStack {
            Button("Switch to Dark") {
                isDarkMode = true
            }
            .padding()
            
            Button("Switch to White") {
                isDarkMode = false
            }
            .padding()
            
            Button("Result Builder") {
                debugPrint("Build numbers: ", tester.buildNumbers())
                
                debugPrint("Build: ", tester.build(showBonus: false))
            }
            .padding()
        }
        .navigationTitle("Property Wrapper")
        .onReceive($isDarkMode) { newValue in
            debugPrint("isDarkMode changed to \(newValue)")
        }
    }
    
    
}

#Preview {
    PropertyWrapperView()
}
