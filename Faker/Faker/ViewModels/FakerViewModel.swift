//
//  FakerViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Foundation

class FakerViewModel: ObservableObject {
    static var shared: FakerViewModel = FakerViewModel()
    private init() {}
    
    @Published private(set) var accounts: [AccountViewModel?] = []
    private let queue = DispatchQueue(label: "com.faker.purchase")
    
    //MARK:-
    func bulkAccountsLoading() {
        if let path = Bundle.main.path(forResource: "Users", ofType: "plist") {
            if let users = NSArray(contentsOfFile: path) {
                print("bulk loading \(users.count) accounts")
                
                if let array = [AccountViewModel].deserialize(from: users) {
                    self.accounts = array
                }
                return
            }
        }
        
        print("read plist error")
    }
    
    func bulkPurchasing() {
        queue.async {
            let count = self.accounts.count
            
            for (idx, viewModel) in self.accounts.enumerated() {
                viewModel?.purchase { [weak self] in
                    DispatchQueue.main.async {
                        // https://stackoverflow.com/questions/57459727/why-is-an-observedobject-array-not-updated-in-my-swiftui-application
                        self?.objectWillChange.send()
                    }
                }
                print("idx[\(idx)] purchase")
                
                if idx == count - 1 {
                    print("bulk purchasing finished!")
                }
                
                sleep(1)    // 1s
            }
        }
    }
}
