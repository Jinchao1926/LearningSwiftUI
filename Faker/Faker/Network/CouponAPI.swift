//
//  CouponAPI.swift
//  Faker
//
//  Created by 林锦超 on 2022/1/2.
//

import Moya

let CouponProvider = MoyaProvider<CouponAPI>()

enum CouponAPI {
    case list(token: String)
}

extension CouponAPI: FakerNetwork {
    var baseURL: URL { URL(string: "https://m.mallcoo.cn/a/coupon/API/")! }
    
    var path: String {
        switch self {
        case .list:
            return "mycoupon/GetNotAboutToExpireCoupon"
        }
    }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .list(let token):
            /*
             {
                 "MinID": 0,
                 "PageSize": 50,
                 "MallID": "10025",
                 "PlatformTypeList": [1],
                 "Header": {
                     "Token": "wmGn7I_nWkmkXUHxoJgmfgFcbAFy3qRk,15047"
                 }
             }
             */
            let header = [ "Token": token ]
            parmeters = [ "MallID": 10025,
                          "MinID": 0,
                          "PlatformTypeList": [1],
                          "PageSize": 50,
                          "Header": header ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        }
    }
}

