//
//  VipAPI.swift
//  Faker
//
//  Created by Jinchao.Lin on 2022/10/22.
//

import Moya

let VipProvider = MoyaProvider<VipAPI>()

enum VipAPI {
    case vip(token: String)
    case vipExpiration(token: String)
}

extension VipAPI: FakerNetwork {
    var baseURL: URL { URL(string: "https://m.mallcoo.cn/")! }

    var path: String {
        switch self {
        case .vip:
            return "api/user/user/GetUserAndMallCard"
        case .vipExpiration:
            return "a/vip/API/MemberPlus/Get"
        }
    }

    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .vip(let token):
            /*
             * {
             "MallID":10025,
             "Header":{"Token":"dwS2-42cDkGigqe8HPuxIQlxo_jmuWFU,15047"}
             }
             */
            let header = [ "Token": token ]
            parmeters = [ "MallId": "10025",
                          "Header": header ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)

        case .vipExpiration(let token):
            /*
             * {
             "MallID":10025,
             "Header":{"Token":"dwS2-42cDkGigqe8HPuxIQlxo_jmuWFU,15047"}
             }
             */
            let header = [ "Token": token ]
            parmeters = [ "MallId": "10025",
                          "Header": header ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        }
    }
}
