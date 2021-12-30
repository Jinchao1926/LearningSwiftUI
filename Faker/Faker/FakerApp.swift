//
//  FakerApp.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/27.
//

import SwiftUI

@main
struct FakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PurchaseCategoryViewModel())
                .environmentObject(FakerViewModel.shared)
                .environmentObject(SettingViewModel.shared)
                .environmentObject(GiftViewModel())
                .background(Color("GrayBackground"))
                .onAppear {
                    FakerViewModel.shared.bulkAccountsLoading()
                }
        }
    }
}
