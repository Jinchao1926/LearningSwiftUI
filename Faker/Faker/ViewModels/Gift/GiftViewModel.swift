//
//  GiftViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import Foundation

class GiftViewModel: ObservableObject, FakerResponse {
    @Published private(set) var gifts: [GiftModel?] = []
    
    func fetchGiftList() {
        GiftProvider.request(GiftAPI.list) {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let jsonDict = try? response.mapJSON() as? NSDictionary,
                    let array = jsonDict["d"] as? Array<Any> {
                    self.gifts = [GiftModel].deserialize(from: array) ?? []
                }
                
            case let .failure(error):
                debugPrint("error:", error.errorDescription as Any)
                break
            }
        }
    }
}
