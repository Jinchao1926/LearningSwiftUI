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
                    
                    for (idx, category) in self.categories.enumerated() {
                        if let id = category?.id {
                            // fetch version
                            self.fetchPurchaseDetail(tuanID: String(id)) { [weak self] detail in
                                if let newCategoryDetail = detail {
                                    self?.categories[idx] = newCategoryDetail
                                }
                            }
                        }
                        
                    }
                }
                
            case let .failure(error):
                print("error:", error.errorDescription)
                break
            }
        }
    }
    
    private func fetchPurchaseDetail(tuanID: String, completion: @escaping (_ category: PurchaseCategoryModel?) -> Void) {
        PurchaseProvider.request(PurchaseAPI.detail(tuanID: tuanID)) {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let obj = self.format(response)?.0, let dict = obj["Tuan"] as? NSDictionary {
                    let detail = PurchaseCategoryModel.deserialize(from: dict)
                    completion(detail)
                    return
                }
                completion(nil)
                
            case let .failure(error):
                completion(nil)
                print("error:", error.errorDescription)
                break
            }
        }
    }
}
