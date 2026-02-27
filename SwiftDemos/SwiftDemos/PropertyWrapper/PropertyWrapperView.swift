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
        List {
            HStack {
                Button("Switch to Dark") {
                    isDarkMode = true
                }
                Spacer()
                Button("Switch to White") {
                    isDarkMode = false
                }
            }
            .onReceive($isDarkMode) { newValue in
                debugPrint("isDarkMode changed to \(newValue)")
            }
            
            Button("Result Builder") {
                debugPrint("Build numbers: ", tester.buildNumbers())
                debugPrint("Build: ", tester.build(showBonus: false))
            }
            
            LoginView()
                .frame(maxWidth: .infinity, alignment: .center)
            
            ParentToggleView()
                .frame(maxWidth: .infinity, alignment: .center)
            
            AppView()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Property Wrapper")
        .environmentObject(AppState())
    }
}

#Preview {
    PropertyWrapperView()
}
