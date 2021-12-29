//
//  PurchaseViewModel.swift
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
}

class AccountViewModel: HandyJSON, FakerResponse {
    private(set) var phone: String?
    private(set) var password: String?

    private(set) var state: State = .idle
    private(set) var message: String?

    private(set) var user: UserModel?

    func mapping(mapper: HelpingMapper) {
        mapper <<< phone <-- "phone"
        mapper <<< password <-- "password"
        mapper <<< state <-- "state"
    }

    required init() {}

    func purchase(completion: @escaping () -> Void) {
        login { [weak self] loginState, loginError in
            guard let self = self else { return }

            if loginState == .success, let token = self.user?.token {
                // login success
                self.createOrder(with: token) { [weak self] state, error in
                    self?.state = state
                    self?.message = error
                    completion()
                }
                return
            }
            
            self.state = loginState
            self.message = loginError
            completion()
        }
    }

    private func login(completion: @escaping (_ state: State, _ error: String?) -> Void) {
        guard let phone = phone, let password = password else {
            completion(.failure, nil)
            return
        }

        completion(.loading, nil)
        UserProvider.request(UserAPI.login(phone: phone, password: password)) { [weak self] result in
            switch result {
            case let .success(response):
                if let obj = self?.format(response), let dict = obj.0 {
                    self?.user = UserModel.deserialize(from: dict)

                    if let _ = self?.user?.token {
                        completion(.success, nil)
                    }
                    else {
                        print("error:", obj.2)
                        completion(.failure, obj.2)
                    }
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }

    private func createOrder(with token: String, completion: @escaping (_ state: State, _ error: String?) -> Void) {
        completion(.loading, nil)

        PurchaseProvider.request(PurchaseAPI.order(token: token)) { [weak self] result in
            switch result {
            case let .success(response):
                if let jsonDict = self?.format(response) {
                    if let d = jsonDict.0 {
                        // success
                        print("response:", d)
                        completion(.success, nil)
                    }
                    else {
                        print("error:", jsonDict.2)
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

extension AccountViewModel: Equatable {
    static func == (lhs: AccountViewModel, rhs: AccountViewModel) -> Bool {
        return (lhs.phone == rhs.phone &&
                lhs.password == rhs.password &&
                lhs.state == rhs.state &&
                lhs.message == rhs.message)
    }
}

extension AccountViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(phone)
        hasher.combine(password)
        hasher.combine(state)
        hasher.combine(message)
    }
}


/*
struct AccountViewModel: HandyJSON, FakerResponse {
    var phone: String?
    private(set) var password: String?

    private(set) var state: State = .idle
    private(set) var message: String?

    private(set) var user: UserModel?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< phone <-- "phone"
        mapper <<< password <-- "password"
//        mapper <<< state <-- "state"
    }

//    required init() { self.phone = "16605911007"; self.password = "Linger1007" }

    mutating func test() {
        self.state = .success
        self.message = "error message"
    }

    mutating func purchase(completion: @escaping () -> Void) {
        self.state = .success
        self.message = "error message"
        completion()

        return
        /*
        login { [weak self] loginState, loginError in
            guard let self = self else { return }

            if loginState == .success, let token = self.user?.token {
                // login success
                self.createOrder(with: token) { [weak self] state, error in
                    self?.state = state
                    self?.message = error
                    completion()
                }
                return
            }

            self.state = loginState
            self.message = loginError
            completion()
        }*/
    }

    private mutating func login(completion: @escaping (_ state: State, _ error: String?) -> Void) {
        guard let phone = phone, let password = password else {
            completion(.failure, nil)
            return
        }

        completion(.loading, nil)
        UserProvider.request(UserAPI.login(phone: phone, password: password)) { result in
            switch result {
            case let .success(response):
                if let obj = format(response), let dict = obj.0 {
                    self.user = UserModel.deserialize(from: dict)

                    if let _ = user?.token {
                        completion(.success, nil)
                    }
                    else {
                        print("error:", obj.2)
                        completion(.failure, obj.2)
                    }
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }

    private func createOrder(with token: String, completion: @escaping (_ state: State, _ error: String?) -> Void) {
        completion(.loading, nil)

        PurchaseProvider.request(PurchaseAPI.order(token: token)) { result in
            switch result {
            case let .success(response):
                if let jsonDict = format(response) {
                    if let d = jsonDict.0 {
                        // success
                        print("response:", d)
                        completion(.success, nil)
                    }
                    else {
                        print("error:", jsonDict.2)
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

extension AccountViewModel: Hashable {}
*/
