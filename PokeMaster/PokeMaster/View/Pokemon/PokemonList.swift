//
//  PokemonList.swift
//  PokeMaster
//
//  Created by 林锦超 on 2021/8/19.
//

import SwiftUI

struct PokemonList: View {
    @State var expandingIndex: Int?
    
    var body: some View {
        
        // cell 自带分割线
//        List(PokemonViewModel.all) { pokemon in
//            PokemonInfoRow(model: pokemon)
//        }
        
        
        // ScrollView 没有 cell 重用机制
        VStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(PokemonViewModel.all) { pokemon in
                        PokemonInfoRow(model: pokemon, expand: expandingIndex == pokemon.id)
                            .onTapGesture {
                                withAnimation {
                                    expandingIndex = (expandingIndex == pokemon.id) ? nil : pokemon.id
                                }
                            }
                    }
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    PokemonInfoPanel(model: .sample(id: 1))
                }
                .edgesIgnoringSafeArea(.bottom)
            )
        }
        
    }
}

struct PokemonList_Preview: PreviewProvider {
    static var previews: some View {
        return PokemonList()
    }
}
