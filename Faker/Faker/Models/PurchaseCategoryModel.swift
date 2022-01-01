//
//  PurchaseCategoryModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/27.
//

import HandyJSON

struct PurchaseCategoryModel: HandyJSON {
    var id: Int?
    var name: String?
    var type: Int?
    var buyLimit: Int?
    var price: Float?
    var version: Int?
    
    /*
    "Id": 169612,
    "Name": "【开门红】V+会员79团100",
    "Type": 1,
    "BeginTime": 1641002400,
    "Stock": 4000,
    "EndTime": 1641139199,
    "BigImage": "sp_mall/79/18/75/07-2644-4617-9e3f-1ac67d3ba2ee.jpg",
    "SmallImage": "",
    "BuyLimit": 5,
    "MarketPrice": 0.0,
    "Price": 79.0
     */
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< id <-- "Id"
        mapper <<< name <-- "Name"
        mapper <<< type <-- "Type"
        mapper <<< buyLimit <-- "BuyLimit"
        mapper <<< price <-- "Price"
        mapper <<< version <-- "Version"
    }
}

extension PurchaseCategoryModel: Hashable {}
