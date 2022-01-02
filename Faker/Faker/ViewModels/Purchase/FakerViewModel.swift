//
//  FakerViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Foundation
import SwiftUI

class FakerViewModel: ObservableObject {
    static var shared: FakerViewModel = FakerViewModel()
    private init() {}
    
    private var setting: SettingViewModel = SettingViewModel.shared
    
    @Published private(set) var users: [UserViewModel?] = []
    private let queue = DispatchQueue(label: "com.faker.purchase")
    
    //MARK:-
    func bulkAccountsLoading() {
        if let users = AccountViewModel.shared.readPlistUsers() {
            print("bulk loading \(users.count) users")
            
            if let array = [UserViewModel].deserialize(from: users) {
                self.users = array
            }
            return
        }
        
        print("read plist error")
    }
    
    func bulkPurchasing(with category: PurchaseCategoryModel) {
        print("[bulkPurchasing] interval: \(setting.intInterval), groupCount: \(setting.intGroupCount), groupInterval: \(setting.intGroupInterval)")
        
        var isRelogin: Bool = false
        
        queue.async {
            let count = self.users.count
            
            for (idx, viewModel) in self.users.enumerated() {
                viewModel?.purchase(category) { [weak self] state, relogin in
                    print("state: \(state) relogin: \(relogin)")
                    guard let self = self else { return }
                    
                    if state.isFinished {
                        isRelogin = isRelogin || relogin
                        
                        // cache when relogin
                        if idx == count - 1 {
                            if isRelogin {
                                let _ = AccountViewModel.shared.cacheToPlist(users: self.users)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        // https://stackoverflow.com/questions/57459727/why-is-an-observedobject-array-not-updated-in-my-swiftui-application
                        self.objectWillChange.send()
                    }
                }
                
                // log
                print("idx[\(idx)] purchase")
                if idx == count - 1 {
                    print("bulk purchasing finished!")
                    return
                }
                
                // sleep
                if (idx + 1) % self.setting.intGroupCount == 0 {
                    print("grouping")
                    Thread.sleep(forTimeInterval: self.setting.intGroupInterval * 60)   // setting.groupInterval (mins)
                }
                else {
                    Thread.sleep(forTimeInterval: self.setting.intInterval) // setting.interval (s)
                }
            }
        }
    }
    
    func bulkCoupons() {
        var isRelogin: Bool = false
        let count = self.users.count
            
        for (idx, viewModel) in self.users.enumerated() {
            viewModel?.coupon() { [weak self] state, relogin in
                print("state: \(state) relogin: \(relogin)")
                guard let self = self else { return }
                
                if state.isFinished {
                    isRelogin = isRelogin || relogin
                    
                    // cache when relogin
                    if idx == count - 1 {
                        if isRelogin {
                            let _ = AccountViewModel.shared.cacheToPlist(users: self.users)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    // https://stackoverflow.com/questions/57459727/why-is-an-observedobject-array-not-updated-in-my-swiftui-application
                    self.objectWillChange.send()
                }
            }
            
            // log
            print("idx[\(idx)] coupon")
            if idx == count - 1 {
                print("bulk coupons finished!")
                return
            }
            
            // sleep
            Thread.sleep(forTimeInterval: 0.05)
        }
    }
}
