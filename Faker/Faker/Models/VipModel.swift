//
//  VipModel.swift
//  Faker
//
//  Created by Jinchao.Lin on 2022/10/22.
//

import HandyJSON

// MARK: - VipModel
struct VipModel: HandyJSON {
    var cardNo: Int?
    var cardTitle: String?
    var cardTitleUP: String?
    var bonus: Float?

    // In Addition
    var expire: VipExpirationModel?

    /*
     {
         "m": 1,
         "d": {
             "NickName": "糊胡",
             "Mobile": "138***6623",
             "CardNo": "1000011924305857",
             "CardTitle": "璀璨卡",
             "CardTitleUP": "普通会员",
             "UpdateBonus": 0.0,
             "TotalBonus": 20620.0,
             "Bonus": 21505.0
         },
         "e": null
     }
     */
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< cardNo <-- "CardNo"
        mapper <<< cardTitle <-- "CardTitle"
        mapper <<< cardTitleUP <-- "CardTitleUP"
        mapper <<< bonus <-- "Bonus"
    }
}

extension VipModel: Hashable {}

// MARK: - VipExpirationModel
struct VipExpirationModel: HandyJSON {
//    var mallID: Int?
    var nickName: String?
    var expiryTime: String?
    var ExpiryTime: Date?
//    var totalCost: Float?

    /*
     {
         "m": 1,
         "d": {
             "MallID": 10025,
             "Title": "V+会员",
             "Desc": "马上加入V+会员！",
             "NickName": "糊胡",
             "TotalCost": 2020.0,
             "CardLevelID": 7,
             "CardLevelName": "V+会员",
             "ExpiryTime": "2023-09-09",
         },
         "e": "成功"
     }
     */
    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<< mallID <-- "MallID"
        mapper <<< nickName <-- "NickName"
        mapper <<< expiryTime <-- "ExpiryTime"
        mapper <<< ExpiryTime <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
    }
}

extension VipExpirationModel: Hashable {}
