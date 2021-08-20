//
//  BlurView.swift
//  PokeMaster
//
//  Created by 林锦超 on 2021/8/20.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style) {
        print("Init")
        self.style = style
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        print("makeUIView:", view)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("updateUIView:", uiView)
        
        let view: UIView = uiView
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor .constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension View {
    func blurBackground(style: UIBlurEffect.Style) -> some View {
        ZStack {
            BlurView(style: style)
            self
        }
    }
}
