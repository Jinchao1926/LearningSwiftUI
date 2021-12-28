//
//  Tester.swift
//  MallBug
//
//  Created by 林锦超 on 2021/12/25.
//

import Foundation

class Tester {
    /*
    let data = """
18406568956 Hh568956
13293783444 Hh783444
18534898081 Hh898081
18534898083 Hh898083
15534365916 Hh365916
15612327235 Hh327235
15935877339 Hh877339
15534274352 Hh274352
13994828340 Hh828340
18534898853 Hh898853
19834415164 Hh415164
18334837898 Hh837898
15534241201 wenjing2018666
17635356129 Hh356129
18100342226 Hh342226
18435856129 Hh856129
18235196129 Hh196129
13935866129 Hh866129
13934524322 Hh524322
15536900055 Hh900055
18534431322 Hh431322
17582808227 Hh808227
17710065321 Hh065321
18334857366 Hh857366
15234833668 Hh833668
13753818143 Hh818143
18434981428 Hh981428
13994829179 Hh829179
13363583150 Hh583150
18735820960 Hh820960
15934012554 Hh15934012554
13753134859 Hh134859
18535004862 Hh004862
13753818510 Hh818510
18613582639 Hh582639
15810777918 Hh777918
18434377620 Hh377620
15392631033 Hh631033
15333618932 Hh618932
15536843607 Hh843607
18734418973 Hh418973
15135020301 Hh020301
17636508438 Hh508438
18535413129 Hh413129
18834070409 Hh070409
18435145905 Hh145905
15203460937 Hh460937
18035810919 Hh810919
18735809068 Hh123456
"""*/
    let data = """
18406568956 Hh568956
13293783444 Hh783444
18534898081 Hh898081
18534898083 Hh898083
15534365916 Hh365916
15612327235 Hh327235
15935877339 Hh877339
15534274352 Hh274352
13994828340 Hh828340
18534898853 Hh898853
19834415164 Hh415164
18334837898 Hh837898
15534241201 wenjing2018666
17635356129 Hh356129
18100342226 Hh342226
18435856129 Hh856129
18235196129 Hh196129
13753134859 Hh134859
18535004862 Hh004862
13753818510 Hh818510
"""
    func format() {
        let lines = data.components(separatedBy: "\n")
        print("lines.count:", lines.count)
//        print("lines:", lines)
        
        let users: NSMutableArray = NSMutableArray()
        for (_, line) in lines.enumerated() {
            let array = line.components(separatedBy: " ")
            print("array:", array)
            let keyValue = [ "phone": array[0], "password": array[1] ]
            users.add(keyValue)
        }
        
        var directory = NSTemporaryDirectory()
        directory.append(contentsOf: "newUsers.plist")
        users.write(toFile: directory, atomically: true)
        print("destPath:", directory)
        
        
        /*
        if let path = Bundle.main.path(forResource: "Users", ofType: "plist") {
            if let users = NSMutableArray(contentsOfFile: path) {
                print("users:", users)
                
//                if let array = [PluginViewModel].deserialize(from: users)
                    
                for (_, line) in lines.enumerated() {
                    let array = line.components(separatedBy: " ")
                    print("array:", array)
                    let keyValue = [ "phone": array[0], "password": array[1] ]
                    users.add(keyValue)
                }
                
                var directory = NSTemporaryDirectory()
                directory.append(contentsOf: "newUsers.plist")
                print("destPath:", directory)
                users.write(toFile: directory, atomically: true)
            }
        } */
        
        
    }
}
