//
//  GiftView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import SwiftUI

struct GiftView: View {
    @EnvironmentObject var viewModel: GiftExchangeViewModel
    
    var body: some View {
        HStack {
            GiftListView()
            
            //
            VStack {
                HStack {
                    Button {
                        viewModel.timing()
                    } label: {
                        Text("定 时")
                            .modifier(ConfirmTextModifier())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding([.top, .trailing], 8)
                    
                    Spacer()
                    
                    Button {
                        viewModel.doExchange()
                    } label: {
                        Text("测 试")
                            .modifier(ConfirmTextModifier())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding([.top, .trailing], 8)
                }
                
                GiftExchangeView()
            }
            
        }
    }
}
