//
//  UserViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/28.
//

import Foundation
import HandyJSON

enum State: Int {
    case idle = 0
    case loading = 1
    case success = 2
    case failure = 3
    
    var isFinished: Bool { self == .success || self == .failure }
}

class UserViewModel: HandyJSON, FakerResponse {
    private(set) var phone: String?
    private(set) var password: String?
    private(set) var token: String?

    // 优惠券
    private(set) var couponCount: Int = 0

    // Vip 信息
    private(set) var vip: VipModel?
    var isVipExpired: Bool {
        guard let date = vip?.expire?.ExpiryTime else { return false }
        return date < Date()
    }

    // 用户状态
    private(set) var state: State = .idle
    private(set) var message: String?

//    private(set) var user: UserModel?

    func mapping(mapper: HelpingMapper) {
        mapper <<< phone <-- "phone"
        mapper <<< password <-- "password"
        mapper <<< token <-- "token"
//        mapper <<< state <-- "state"
//        mapper <<< message <-- "message"
    }

    required init() {}
}

typealias UserReloginCompletionHandler = (_ state: State, _ reLogin: Bool) -> Void
typealias UserCompletionHandler = (_ state: State, _ error: String?) -> Void

// MARK: - Login
extension UserViewModel {
    private func login(completion: @escaping UserCompletionHandler) {
        guard let phone = phone, let password = password else {
            completion(.failure, nil)
            return
        }

        completion(.loading, nil)
        UserProvider.request(UserAPI.login(phone: phone, password: password)) { [weak self] result in
            switch result {
            case let .success(response):
                if let obj = self?.format(response) {
                    if let dict = obj.0 {
                        self?.token = UserModel.deserialize(from: dict)?.token

                        if let _ = self?.token {
                            completion(.success, nil)
                        }
                        return
                    }
                    completion(.failure, obj.2)
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }
}

// MARK: - Purchase
extension UserViewModel {
    func purchase(_ category: PurchaseCategoryModel, completion: @escaping UserReloginCompletionHandler) {
        if let token = self.token {
            // already logined
            self.createOrder(with: token, category: category) { [weak self] state, error in
                self?.state = state
                self?.message = error
                completion(state, false)
            }
            return
        }
        
        login { [weak self] loginState, loginError in
            guard let self = self else { return }

            if loginState == .success {
                if let token = self.token {
                    // login success
                    self.createOrder(with: token, category: category) { [weak self] state, error in
                        self?.state = state
                        self?.message = error
                        completion(state, true)
                    }
                    return
                }
            }
            
            self.state = loginState
            self.message = loginError
            completion(loginState, true)
        }
    }

    private func createOrder(with token: String, category: PurchaseCategoryModel, completion: @escaping UserCompletionHandler) {
        completion(.loading, nil)

        let tuanID: String = String(category.id ?? 0)
        let count: Int = category.buyLimit ?? 5
        let price: Float = category.price ?? 1
        let version: Int = category.version ?? 6 //6 - 79抵用100
        PurchaseProvider.request(PurchaseAPI.order(token: token, tuanID: tuanID, price: price, count: count, version: version)) { [weak self] result in
            switch result {
            case let .success(response):
                if let jsonDict = self?.format(response) {
                    if let d = jsonDict.0 {
                        // success
                        debugPrint("response:", d)
                        completion(.success, nil)
                    }
                    else {
                        debugPrint("error:", jsonDict.2 as Any)
                        completion(.failure, jsonDict.2)
                    }
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }
}

// MARK: - Coupon
extension UserViewModel {
    func coupon(completion: @escaping UserReloginCompletionHandler) {
        if let token = self.token {
            // already logined
            self.fetchCouponCount(with: token) { [weak self] state, error in
                self?.state = state
                self?.message = error
                completion(state, false)
            }
            return
        }
        
        login { [weak self] loginState, loginError in
            guard let self = self else { return }

            if loginState == .success {
                if let token = self.token {
                    // login success
                    self.fetchCouponCount(with: token) { [weak self] state, error in
                        self?.state = state
                        self?.message = error
                        completion(state, true)
                    }
                    return
                }
            }
            
            self.state = loginState
            self.message = loginError
            completion(loginState, true)
        }
    }
    
    private func fetchCouponCount(with token: String, completion: @escaping UserCompletionHandler) {
        completion(.loading, nil)
        UserProvider.request(UserAPI.couponCount(token: token)) { [weak self] result in
            switch result {
            case let .success(response):
                if let jsonDict = try? response.mapJSON() as? NSDictionary {
                    if let count = jsonDict["d"] as? Int {
                        // success
                        self?.couponCount = count
                        completion(.success, nil)
                    }
                    else {
                        debugPrint("error:", jsonDict["e"] as Any)
                        completion(.failure, jsonDict["e"] as? String)
                    }
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }
}

// MARK: - Vip
extension UserViewModel {
    func vip(completion: @escaping UserReloginCompletionHandler) {
        if let token = self.token {
            // already logined
            self.fetchVip(with: token) { [weak self] state, error in
                self?.state = state
                self?.message = error
                completion(state, false)
            }
            return
        }

        // login
        login { [weak self] loginState, loginError in
            guard let self = self, loginState == .success, let token = self.token else {
                self?.state = loginState
                self?.message = loginError
                completion(loginState, true)
                return
            }

            // login success
            self.fetchVip(with: token) { [weak self] state, error in
                self?.state = state
                self?.message = error
                completion(state, true)
            }
        }
    }

    private func fetchVip(with token: String, completion: @escaping UserCompletionHandler) {
        completion(.loading, nil)
        VipProvider.request(VipAPI.vip(token: token)) { [weak self] result in
            switch result {
            case let .success(response):
                if let obj = self?.format(response) {
                    if let dict = obj.0 {
                        // success
                        self?.vip = VipModel.deserialize(from: dict)
                        self?.fetchVipExpiration(with: token, completion: completion)
                        return
                    }
                    completion(.failure, obj.2)
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }

    private func fetchVipExpiration(with token: String, completion: @escaping UserCompletionHandler) {
        VipProvider.request(VipAPI.vipExpiration(token: token)) { [weak self] result in
            switch result {
            case let .success(response):
                if let obj = self?.format(response) {
                    if let dict = obj.0 {
                        // success
                        let expirationModel = VipExpirationModel.deserialize(from: dict)
                        self?.vip?.expire = expirationModel
                        completion(.success, nil)
                        return
                    }
                    completion(.failure, obj.2)
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }
}

// MARK: - Equatable & Hashable
extension UserViewModel: Equatable {
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return (lhs.phone == rhs.phone &&
                lhs.password == rhs.password &&
                lhs.state == rhs.state &&
                lhs.message == rhs.message)
    }
}

extension UserViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(phone)
        hasher.combine(password)
        hasher.combine(state)
        hasher.combine(message)
    }
}
