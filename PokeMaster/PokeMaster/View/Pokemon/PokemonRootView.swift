//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by 林锦超 on 2021/8/20.
//

import SwiftUI

struct PokemonRootView: View {
    var body: some View {
        NavigationView {
            PokemonList().navigationTitle("宝可梦列表")
        }
    }
}

struct PokemonRootView_Preview: PreviewProvider {
    static var previews: some View {
        return PokemonRootView()
    }
}
