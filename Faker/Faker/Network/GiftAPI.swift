//
//  GiftAPI.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import Moya

let GiftProvider = MoyaProvider<GiftAPI>()

enum GiftAPI {
    case list
    case exchange(token: String, giftID: String)
}

extension GiftAPI: FakerNetwork {
    var path: String {
        switch self {
        case .list:
            return "gift/giftmanager/GetGiftInfoList"
        case .exchange(_, _):
            return "gift/giftmanager/DoExchange"
        }
    }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .list:
            /* {
             "mid": "11403",
             "pi": 1,   //page
             "ps": 50,  //page size
             "cid": 0,
             "bs": null,
             "ce": 0
             }
             */
            parmeters = [ "mid": "11403",
                          "pi": 1,
                          "ps": 50,
                          "cid": 0,
                          "ce": 0] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .exchange(let token, let giftID):
            /* {
                 "mid": "11403",
                 "gid": "146496",
                 "c": "1",
                 "s": "5",
                 "cbu": "//m.mallcoo.cn/a/gift/11403/result?oid=",
                 "exp": null,
                 "Header": {
                     "Token": "3saIR4hCTkmPJwqI6FdJZweVYSnfRJs0,16419"
                 }
             }
             */
            let header = [ "Token": token ]
            parmeters = [ "mid": "11403",
                          "gid": giftID,
                          "c": "1",
                          "s": "5",
                          "Header": header ] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        }
    }
}
