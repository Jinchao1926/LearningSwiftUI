//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by 林锦超 on 2021/8/20.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView()
                .navigationTitle("设置")
//                .navigationBarTitle("设置")
        }
    }
}

struct SettingRootView_Preview: PreviewProvider {
    static var previews: some View {
        SettingRootView()
    }
}
