//
//  CouponViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2022/1/2.
//

import Foundation

class CouponViewModel: ObservableObject, FakerResponse {
    @Published private(set) var coupons: [CouponModel?] = []
    
    func fetchCouponList(token: String) {
        CouponProvider.request(CouponAPI.list(token: token)) {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let jsonDict = try? response.mapJSON() as? NSDictionary,
                    let array = jsonDict["d"] as? Array<Any> {
                    self.coupons = [CouponModel].deserialize(from: array) ?? []
                }
                
            case let .failure(error):
                debugPrint("error:", error.errorDescription as Any)
                break
            }
        }
    }
    
    /*
    @Published private(set) var count: Int = 0
    
    func fetchCouponCount(token: String) {
        CouponProvider.request(CouponAPI.count(token: token)) {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let jsonDict = try? response.mapJSON() as? NSDictionary,
                    let count = jsonDict["d"] as? Int {
                    self.count = count
                }
                
            case let .failure(error):
                print("error:", error.errorDescription)
                break
            }
        }
    } */
}
