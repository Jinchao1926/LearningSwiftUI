//
//  AccountViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/29.
//

import Foundation
import SwiftUI

class AccountViewModel {
    static var shared: AccountViewModel = AccountViewModel()
    private init() {}
    
    var path: String {
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        documentsPath.append(contentsOf: "/Users.plist")
        return documentsPath
    }
    
    var errorLines: [String] = []
    
    // MARK:- Export
    func exportToPlist(with data: String) -> Bool {
        errorLines.removeAll()
        
        // separate to lines
        let lines = data.components(separatedBy: "\n")
        print("lines.count:", lines.count)
        
        let users: NSMutableArray = NSMutableArray()
        for (idx, line) in lines.enumerated() {
            // separate to account key-value
            let trimedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimedLine.count > 0 {
                let array = trimedLine.components(separatedBy: " ")
                print("[\(idx)] array:", array)
                
                if array.count == 2 {
                    let keyValue = [ "phone": array[0], "password": array[1] ]
                    users.add(keyValue)
                }
                else {
                    errorLines.append(line)
                }
            }
        }
        
        let path = self.path
        print("errorLines:", errorLines)
        
        let ret = users.write(toFile: path, atomically: true)
        if ret {
            FakerViewModel.shared.bulkAccountsLoading()
        }
        return ret
    }
    
    func readPlistUsers() -> NSArray? {
        return NSArray(contentsOfFile: self.path)
    }
    
    func readPlistUserStrings() -> String {
        if let users = readPlistUsers() {
            let lines: NSMutableArray = NSMutableArray()
            
            for (_, user) in users.enumerated() {
                if let dict = user as? NSDictionary,
                    let phone = dict["phone"] as? String,
                    let password = dict["password"] as? String {
                    let line = String(format: "%@ %@", phone, password)
                    lines.add(line)
                }
            }
            
            return lines.componentsJoined(by: "\n")
        }
        
        return ""
    }
}
