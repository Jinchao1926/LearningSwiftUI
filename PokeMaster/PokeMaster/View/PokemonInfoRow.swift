//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by 林锦超 on 2021/8/18.
//

import SwiftUI

struct PokemonInfoRow: View {
    let model: PokemonViewModel = PokemonViewModel.sample(id: 1)
    
    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()    //默认情况下图片绘制和 frame 无关
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: HorizontalAlignment.trailing, spacing: 0) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }.padding(.top, 12)
            //
            HStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Fav")
                })
                Button(action: {
                    
                }, label: {
                    Text("Panel")
                })
                Button(action: {
                    
                }, label: {
                    Text("Web")
                })
            }
        }.background(Color.green)
    }
}
