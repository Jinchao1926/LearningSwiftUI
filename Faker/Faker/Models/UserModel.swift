//
//  UserModel.swift
//  MallBug
//
//  Created by 林锦超 on 2021/12/25.
//

import HandyJSON

struct UserModel: HandyJSON {
    var uid: Int?
    var mallID: Int?
    var token: String?
    var projectType: Int?
    
    /*
     {
     "m": 1,
     "d": {
         "UID": 68868253,
         "MallID": 10025,
         "Token": "ClFy4O0AeU-TFmuUIYM97QyTjzGwHRKE",
         "ProjectType": 15047,
         "Mobile": null
     },
     "e": null
     }
     */
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< uid <-- "UID"
        mapper <<< mallID <-- "MallID"
        mapper <<< token <-- "Token"
        mapper <<< projectType <-- "ProjectType"
    }
}

extension UserModel: Hashable {}
