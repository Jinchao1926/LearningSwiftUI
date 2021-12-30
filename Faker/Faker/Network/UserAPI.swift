//
//  UserAPI.swift
//  MallBug
//
//  Created by 林锦超 on 2021/12/24.
//

import Moya

let UserProvider = MoyaProvider<UserAPI>()

enum UserAPI {
    case login(phone: String, password: String)
}

extension UserAPI: FakerNetwork {
    var path: String {
        switch self {
        case .login(_, _):
            return "passport/user/Login"
        }
    }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .login(let phone, let password):
            /*
             * {
             "MallID": 10025,
             "Mobile": "16605911007",
             "SNSType": 0,
             "Pwd": "Linger1007",   //密码
             "VCode": "",   //验证码
             "LoginType": 1,
             "OauthID": null,
             "Keyword": "",
             "Scene": 4,
             "GraphicType": 2,
             "Header": {
                 "Token": null
                }
             }
             */
            parmeters = [ "MallID": 10025,
                          "Mobile": phone,
                          "Pwd": password,
                          "SNSType": 0,
                          "LoginType": 1,   //1:密码登录 2:验证码登录
                          "Scene": 4,
                          "GraphicType": 2] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
        }
    }
}
