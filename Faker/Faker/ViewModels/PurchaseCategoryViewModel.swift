//
//  PurchaseCategoryViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Foundation

class PurchaseCategoryViewModel: ObservableObject, FakerResponse {
    @Published private(set) var categories: [PurchaseCategoryModel?] = []
    
    func fetchPurchaseList() {
        PurchaseProvider.request(PurchaseAPI.category) {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let obj = self.format(response)?.0, let array = obj["Tuans"] as? Array<Any> {
                    self.categories = [PurchaseCategoryModel].deserialize(from: array) ?? []
                }
                
            case let .failure(error):
                print("error:", error.errorDescription)
                break
            }
        }
    }
}
