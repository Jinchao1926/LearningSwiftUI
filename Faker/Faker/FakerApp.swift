//
//  FakerApp.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/27.
//

import SwiftUI

@main
struct FakerApp: App {
    var title: String {
        if let version = Bundle.main.releaseVersionNumber,
            let build = Bundle.main.buildVersionNumber {
            return "🐱Faker (v\(version)-build\(build))"
        }
        return "🐱Faker"
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PurchaseCategoryViewModel())
                .environmentObject(FakerViewModel.shared)
                .environmentObject(SettingViewModel.shared)
                .environmentObject(CouponViewModel())
                .environmentObject(GiftViewModel())
                .environmentObject(GiftExchangeViewModel())
                .background(Color("GrayBackground"))
                .onAppear {
                    FakerViewModel.shared.bulkAccountsLoading()
                }
                .navigationTitle(title)
        }
    }
}
