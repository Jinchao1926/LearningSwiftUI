//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by 林锦超 on 2021/8/18.
//

import SwiftUI

struct PokemonInfoRow: View {
    let model: PokemonViewModel
    var expand: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()    //默认情况下图片绘制和 frame 无关
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }.padding(.top, 12)
            Spacer()
            //
            HStack(spacing: 20) {
                Spacer()
                // SF Symbols
                Button(action: {
                    
                }, label: {
                    Image(systemName: "star")
                        .modifier(ToolButtonModifier())
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                })
            }
            .padding(.bottom, 12)
            .opacity(expand ? 1.0 : 0.0)
            .frame(maxHeight: (expand ? .infinity : 0))
        }
        .frame(height: expand ? 120 : 80)
        .padding(.leading, 20)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 3))
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.white, model.color]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
            }
        )
        .padding(.horizontal)
//        .animation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) //弹性动画
//        .onTapGesture(perform: {
//            withAnimation {
//                expand.toggle()
//            }
//        })
    }
}

struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokemonInfoRow(model: PokemonViewModel.sample(id: 1), expand: false)
            PokemonInfoRow(model: PokemonViewModel.sample(id: 2), expand: true)
            PokemonInfoRow(model: PokemonViewModel.sample(id: 3), expand: false)
        }
    }
}

// ViewModifier 可以跨越页面作用在任意 View 上
struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 25, height: 25)
            .font(.system(size: 25))
            .foregroundColor(.white)
    }
}
