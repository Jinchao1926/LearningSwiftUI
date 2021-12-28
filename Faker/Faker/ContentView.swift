//
//  ContentView.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PurchaseCategoryView()
            .background(Color(hex: "f9f9f9"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
