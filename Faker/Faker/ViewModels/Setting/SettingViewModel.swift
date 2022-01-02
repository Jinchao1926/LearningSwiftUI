//
//  SettingViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/29.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    static var shared: SettingViewModel = SettingViewModel()
    private init() {
        readCache()
    }
    
    @Published var interval: String = "1"   //s
    @Published var groupCount: String = "500"
    @Published var groupInterval: String = "1"  //min
    
    var intInterval: TimeInterval { TimeInterval(interval) ?? 1 }
    var intGroupCount: Int { Int(groupCount) ?? 500 }
    var intGroupInterval: TimeInterval { TimeInterval(groupInterval) ?? 1 }
    
    func readCache() {
        let standard = UserDefaults.standard
        if let interval = standard.string(forKey: "interval") {
            self.interval = interval
        }
        if let groupCount = standard.string(forKey: "groupCount") {
            self.groupCount = groupCount
        }
        if let groupInterval = standard.string(forKey: "groupInterval") {
            self.groupInterval = groupInterval
        }
    }
    
    func synchronize() -> Bool {
        print("interval: \(interval), groupCount: \(groupCount), groupInterval: \(groupInterval)")
        
        let standard = UserDefaults.standard
        standard.set(interval, forKey: "interval")
        standard.set(groupCount, forKey: "groupCount")
        standard.set(groupInterval, forKey: "groupInterval")
        return standard.synchronize()
    }
}
