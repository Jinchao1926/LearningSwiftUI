//
//  FakerResponse.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Moya

protocol FakerResponse {
    /*
     * m - Int (code)
     * d - Object (true response)
     * e - String (message)
     */
//    var m: Int { get }
//    var d: Any { get }
//    var e: String { get }
    
    func format(_ response: Response) -> (NSDictionary?, Int?, String?)?
}

extension FakerResponse {
    func format(_ response: Response) -> (NSDictionary?, Int?, String?)? {
        guard let jsonDict = try? response.mapJSON() as? NSDictionary else { return nil }
        
        return (jsonDict["d"] as? NSDictionary, jsonDict["m"] as? Int, jsonDict["e"] as? String)
    }
}
