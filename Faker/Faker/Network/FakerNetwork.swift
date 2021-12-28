//
//  FakerNetwork.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Moya

private let apiHost: String = "https://m.mallcoo.cn/api/"

// Enable Network ability:  https://developer.apple.com/documentation/xcode/adding-capabilities-to-your-app?preferredLanguage=occ
protocol FakerNetwork: TargetType {
    
}

extension FakerNetwork {
    var baseURL: URL { URL(string: apiHost)! }
    
    var method: Method { .post }
    
    var headers: [String : String]? {
        return ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"]
    }
}


