//
//  PurchaseAPI.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Moya

let PurchaseProvider = MoyaProvider<PurchaseAPI>()

enum PurchaseAPI {
    case category
    case detail(tuanID: String)
    case order(token: String, tuanID: String, price: Float, count: Int = 5, version: Int)
}

extension PurchaseAPI: FakerNetwork {
    var path: String {
        switch self {
        case .category:
            return "tuan/Tuan/List"//?_type=2"
        case .detail:
            return "tuan/Tuan/DetailConfirm"
        case .order:
            return "tuan/Order/CreateNew"//?_type=2"
        }
    }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .category:
            /* {
             "MallId": "10025",
             "CategoryId": "5084",
             "PageIndex": 0,
             "Count": 10,
             "QueryCategory": true,
             "QueryListType": true,
             "Header": {
                 "Token": "ClFy4O0AeU-TFmuUIYM97QyTjzGwHRKE,15047"
                }
             }
             */
            parmeters = [ "MallID": 10025,
//                          "CategoryId": "5084",
                          "PageIndex": 0,
                          "Count": 10,
                          "QueryCategory": false,
                          "QueryListType": true ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
        
        case .detail(let tuanID):
            /* {
                "MallID": "10025",
                 "TuanId": "169612"
             }
             */
            parmeters = [ "TuanId": tuanID,
                          "MallID": "10025" ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        
        case .order(let token, let tuanID, let price, let count, let version):
            /*
             * {
             "Count": "5",
             "TuanId": "169609",
             "TuanPrice": 85,
             "MallId": "10025",
             "datasource": "2",
             "TuanVersion": 9,
             "SSL": true,
             "CaptchKey": "",
             "BuyerMessage": "",
             "_R": "98b68fa1-2419-521d-b4f1-6f2be43dc203",
             "Header": {
                 "Token": "ClFy4O0AeU-TFmuUIYM97QyTjzGwHRKE,15047"
                }
             }
             */
            let header = [ "Token": token ]
            parmeters = [ "TuanId": tuanID,
                          "Count": String(count),
                          "TuanPrice": price,
                          "MallId": "10025",
                          "datasource": "2",
                          "TuanVersion": version,
                          "SSL": true,
                          "CaptchKey": "",
                          "BuyerMessage": "",
                          "_R": "98b68fa1-2419-521d-b4f1-6f2be43dc203",
                          "Header": header ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        }
    }
}
