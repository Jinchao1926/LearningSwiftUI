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
}

extension GiftAPI: FakerNetwork {
    var path: String {
        switch self {
        case .list:
            return "gift/giftmanager/GetGiftInfoList"
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
        }
    }
}
