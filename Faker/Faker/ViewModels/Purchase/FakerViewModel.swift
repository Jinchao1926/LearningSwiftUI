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
//    @EnvironmentObject private var setting: SettingViewModel
    
    @Published private(set) var users: [UserViewModel?] = []
    private let queue = DispatchQueue(label: "com.faker.purchase")
    
    //MARK:-
    func bulkReset() {
        for user in users {
            user?.reset()
        }
        self.objectWillChange.send()
    }
    
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
        
        queue.async {
            let count = self.users.count
            
            for (idx, viewModel) in self.users.enumerated() {
                viewModel?.purchase(category) { [weak self] in
                    DispatchQueue.main.async {
                        // https://stackoverflow.com/questions/57459727/why-is-an-observedobject-array-not-updated-in-my-swiftui-application
                        self?.objectWillChange.send()
                    }
                }
                print("idx[\(idx)] purchase")
                
                if idx == count - 1 {
                    print("bulk purchasing finished!")
                }
                
                if (idx + 1) % self.setting.intGroupCount == 0 {
                    print("grouping")
                    sleep(self.setting.intGroupInterval * 60)   // setting.groupInterval (mins)
                }
                else {
                    sleep(self.setting.intInterval)    // setting.interval (s)
                }
            }
        }
    }
}
