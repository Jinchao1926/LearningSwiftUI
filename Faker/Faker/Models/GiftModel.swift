//
//  GiftModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import HandyJSON

struct GiftModel: HandyJSON {
    var id: Int?
    var name: String?
    var price: NSNumber?
    var giftCategoryID: Int?
    var remain: Int?    //库存
    var sold: Int?      //已售
    
    /*
     "id": 143641,
     "n": "Apple AirPods",
     "p": "sp_mall/64/ze/yc/e8-ffdf-4714-830c-e28f0dd0ff50.jpg",
     "b": 100000.0,
     "sc": 0,
     "ec": 4,
     "rc": 0,
     "mcc": 1,
     "iht": true,
     "tn": "sp_mall/6e/z8/yf/d8-a157-406c-bd2d-aa580a011e82.jpg",
     "OrderRank": 68,
     "GiftCategoryID": 7181,
     "CurrencyType": 1,
     "CurrencyValue": 0.0,
     "OnlineTime": "2021-11-02 14:00:00",
     "OfflineTime": "2021-12-31 22:00:00",
     "IsNeedCard": false,
     "MPPrice": 100000.0,
     "IsAdvancedRestriction": false,
     "AdvancedRestriction": 1,
     "MallCardTypeList": [],
     "MarketPrice": null,
     "PayType": 0,
     "PayMoney": 0.0,
     "CouponType": null,
     "IsNotShowSellStock": false,
     "ExchangeStartTime": "2021-12-17 09:00:00",
     "ExchangeEndTime": "2021-12-31 22:00:00",
     "IsOpenDiscount": false,
     "DiscountBonus": 100000.0,
     "DiscountPayMoney": 0.0,
     "IsVipPrice": false,
     "CurrentTime": "2021-12-30 15:51:55",
     "IsAboutBegin": false,
     "Remark": ""
     */
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< id <-- "id"
        mapper <<< name <-- "n"
        mapper <<< price <-- "b"
        mapper <<< giftCategoryID <-- "GiftCategoryID"
        mapper <<< remain <-- "sc"
        mapper <<< sold <-- "ec"
    }
}

extension GiftModel: Hashable {}
