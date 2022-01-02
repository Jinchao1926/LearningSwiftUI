//
//  CouponModel.swift
//  Faker
//
//  Created by 林锦超 on 2022/1/2.
//

import HandyJSON
struct CouponModel: HandyJSON {
    var ruleNo: String?
    var name: String?
    
    /*
     "RuleNo": "KQ10025202112160002",
     "GroupRuleNo": null,
     "ShopRuleNo": null,
     "Name": "开门红100元代金券（V+79团100）",
     "Subtitle": "开门红V+79团100",
     "SingleCosts": 0.0,
     "ReduceMoney": 100.0,
     "Deductible": null,
     "DiscountAmount": null,
     "InsteadMoney": 0.0,
     "InsteadTime": 0,
     "Subsidy": 0.0,
     "ShowType": 1,
     "Type": 1
     */
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< ruleNo <-- "RuleNo"
        mapper <<< name <-- "Name"
    }
}
